import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../models/recipe_ingredient.dart';
import '../models/step.dart' as model;
import '../models/category.dart';
import '../services/recipe_service.dart';
import '../providers/recipes_provider.dart';
import '../providers/categories_provider.dart';

class RecipeFormScreen extends ConsumerStatefulWidget {
  final int? recipeId; // null = novi recept

  const RecipeFormScreen({super.key, this.recipeId});

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  Category? _selectedCategory;
  bool _loading = false;
  bool _initialLoading = true;

  final List<_IngredientForm> _ingredientForms = [];

  final List<TextEditingController> _stepControllers = [];

  bool get isEditing => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadExistingRecipe();
    } else {
      setState(() => _initialLoading = false);
    }
  }

  Future<void> _loadExistingRecipe() async {
    try {
      final recipe = await RecipeService.getRecipe(widget.recipeId!);
      setState(() {
        _nameController.text = recipe.name;
        _descriptionController.text = recipe.description ?? '';
        _prepTimeController.text = recipe.prepTimeMin?.toString() ?? '';
        _servingsController.text = recipe.servings?.toString() ?? '';

        _ingredientForms.addAll(
          (recipe.ingredients ?? []).map(
            (ing) => _IngredientForm(
              nameController: TextEditingController(text: ing.name),
              quantityController: TextEditingController(
                text: ing.quantity.toString(),
              ),
              unitController: TextEditingController(text: ing.unit),
              notesController: TextEditingController(text: ing.notes ?? ''),
            ),
          ),
        );

        _stepControllers.addAll(
          (recipe.steps ?? []).map(
            (step) => TextEditingController(text: step.description),
          ),
        );

        _initialLoading = false;
      });

      final categoriesAsync = ref.read(categoriesProvider);
      categoriesAsync.whenData((cats) {
        final match = cats.where((c) => c.id == recipe.categoryId).firstOrNull;
        if (match != null) setState(() => _selectedCategory = match);
      });
    } catch (e) {
      setState(() => _initialLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _servingsController.dispose();
    for (final f in _ingredientForms) {
      f.dispose();
    }
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Odaberi kategoriju.')));
      return;
    }

    setState(() => _loading = true);

    try {
      final recipe = Recipe(
        id: widget.recipeId,
        categoryId: _selectedCategory!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        prepTimeMin: int.tryParse(_prepTimeController.text),
        servings: int.tryParse(_servingsController.text),
        ingredients: _ingredientForms
            .where((f) => f.nameController.text.trim().isNotEmpty)
            .map(
              (f) => RecipeIngredient(
                name: f.nameController.text.trim(),
                quantity: double.tryParse(f.quantityController.text) ?? 0,
                unit: f.unitController.text.trim(),
                notes: f.notesController.text.trim().isEmpty
                    ? null
                    : f.notesController.text.trim(),
              ),
            )
            .toList(),
        steps: _stepControllers
            .asMap()
            .entries
            .where((e) => e.value.text.trim().isNotEmpty)
            .map(
              (e) => model.RecipeStep(
                orderNum: e.key + 1,
                description: e.value.text.trim(),
              ),
            )
            .toList(),
      );

      if (isEditing) {
        await ref.read(recipesProvider.notifier).updateRecipe(recipe);
        if (mounted) context.pop(true);
      } else {
        final id = await ref.read(recipesProvider.notifier).addRecipe(recipe);
        if (mounted) context.pushReplacement('/recipe/$id');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Greška pri čuvanju recepta.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Uredi recept' : 'Novi recept'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sačuvaj'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Naziv
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Naziv recepta *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Naziv je obavezan.' : null,
            ),
            const SizedBox(height: 16),

            categoriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('Greška pri učitavanju kategorija.'),
              data: (categories) => DropdownButtonFormField<Category>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategorija *',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text('${cat.icon ?? ''} ${cat.name}'),
                      ),
                    )
                    .toList(),
                onChanged: (cat) => setState(() => _selectedCategory = cat),
                validator: (v) => v == null ? 'Odaberi kategoriju.' : null,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Vreme (min)',
                      border: OutlineInputBorder(),
                      suffixText: 'min',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Porcija',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Kratak opis (opciono)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 24),

            _buildIngredientSection(),

            const SizedBox(height: 24),

            _buildStepsSection(),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _loading ? null : _save,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Sačuvaj'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Otkaži'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sastojci',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => setState(
                () => _ingredientForms.add(
                  _IngredientForm(
                    nameController: TextEditingController(),
                    quantityController: TextEditingController(),
                    unitController: TextEditingController(),
                    notesController: TextEditingController(),
                  ),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Dodaj'),
            ),
          ],
        ),
        const Divider(),
        if (_ingredientForms.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Nema sastojaka. Dodaj prvi.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ...(_ingredientForms.asMap().entries.map((entry) {
          final i = entry.key;
          final form = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: form.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Naziv *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Obavezno'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: form.quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Količina *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Obavezno'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: form.unitController,
                          decoration: const InputDecoration(
                            labelText: 'Jed.',
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            setState(() => _ingredientForms.removeAt(i)),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: form.notesController,
                    decoration: const InputDecoration(
                      labelText: 'Napomena (opciono)',
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        })),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Način pripreme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () =>
                  setState(() => _stepControllers.add(TextEditingController())),
              icon: const Icon(Icons.add),
              label: const Text('Dodaj korak'),
            ),
          ],
        ),
        const Divider(),
        if (_stepControllers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Nema koraka (opciono).',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ...(_stepControllers.asMap().entries.map((entry) {
          final i = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      hintText: 'Opis koraka ${i + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    entry.value.dispose();
                    setState(() => _stepControllers.removeAt(i));
                  },
                ),
              ],
            ),
          );
        })),
      ],
    );
  }
}

class _IngredientForm {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController notesController;

  _IngredientForm({
    required this.nameController,
    required this.quantityController,
    required this.unitController,
    required this.notesController,
  });

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    unitController.dispose();
    notesController.dispose();
  }
}
