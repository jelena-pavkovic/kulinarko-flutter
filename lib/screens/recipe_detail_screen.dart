import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../models/recipe_ingredient.dart';
import '../models/step.dart' as model;
import '../services/recipe_service.dart';
import '../services/shopping_service.dart';
import '../providers/recipes_provider.dart';
import '../widgets/ingredient_row.dart';
import '../widgets/step_row.dart';
import '../providers/shopping_provider.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  Recipe? _recipe;
  List<RecipeIngredient> _ingredients = [];
  List<model.RecipeStep> _steps = [];
  bool _loading = true;
  String? _error;

  final Map<int, IngredientState> _ingredientStates = {};

  final Set<int> _completedSteps = {};

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final recipe = await RecipeService.getRecipe(widget.recipeId);
      setState(() {
        _recipe = recipe;
        _ingredients = recipe.ingredients ?? [];
        _steps = recipe.steps ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _toggleIngredient(int ingredientId) {
    setState(() {
      final current =
          _ingredientStates[ingredientId] ?? IngredientState.unchecked;
      switch (current) {
        case IngredientState.unchecked:
          _ingredientStates[ingredientId] = IngredientState.haveIt;
          break;
        case IngredientState.haveIt:
          _ingredientStates[ingredientId] = IngredientState.needToBuy;
          break;
        case IngredientState.needToBuy:
          _ingredientStates[ingredientId] = IngredientState.unchecked;
          break;
      }
    });
  }

  Future<void> _addToShoppingList() async {
    final toAdd = _ingredients.where((ing) {
      final state = _ingredientStates[ing.id] ?? IngredientState.unchecked;
      return state == IngredientState.needToBuy;
    }).toList();

    if (toAdd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Označi crvenom bojom sastojke koje treba kupiti.'),
        ),
      );
      return;
    }

    try {
      for (final ing in toAdd) {
        await ShoppingService.addItem(
          name: ing.name,
          quantity: ing.quantity,
          unit: ing.unit,
        );
      }

      ref.invalidate(shoppingProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${toAdd.length} sastojaka dodano u listu.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Greška pri dodavanju u listu.')),
        );
      }
    }
  }

  Future<void> _editRecipe() async {
    final changed = await context.push<bool>('/recipe/${widget.recipeId}/edit');
    if (changed == true) {
      _loadRecipe(); // eksplicitno ponovo dohvati sveže podatke
    }
  }

  Future<void> _deleteRecipe() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Obriši recept'),
        content: Text('Da li si sigurna da želiš obrisati "${_recipe?.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Obriši'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(recipesProvider.notifier).deleteRecipe(widget.recipeId);
        if (mounted) context.go('/');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Greška pri brisanju recepta.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              const Text('Nije moguće učitati recept.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadRecipe,
                child: const Text('Pokušaj ponovo'),
              ),
            ],
          ),
        ),
      );
    }

    final recipe = _recipe!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(recipe.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Uredi',
                onPressed: _editRecipe,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Obriši',
                onPressed: _deleteRecipe,
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      if (recipe.prepTimeMin != null)
                        Chip(
                          avatar: const Icon(Icons.timer_outlined, size: 16),
                          label: Text('${recipe.prepTimeMin} min'),
                        ),
                      if (recipe.servings != null)
                        Chip(
                          avatar: const Icon(Icons.people_outline, size: 16),
                          label: Text('${recipe.servings} porcija'),
                        ),
                    ],
                  ),

                  if (recipe.description != null &&
                      recipe.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(recipe.description!),
                  ],

                  const SizedBox(height: 24),

                  const Text(
                    'Sastojci',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  if (_ingredients.isEmpty)
                    const Text('Nema unesenih sastojaka.')
                  else
                    ...(_ingredients.map(
                      (ing) => IngredientRow(
                        ingredient: ing,
                        state:
                            _ingredientStates[ing.id] ??
                            IngredientState.unchecked,
                        onTap: () => _toggleIngredient(ing.id!),
                      ),
                    )),

                  const SizedBox(height: 8),

                  const Row(
                    children: [
                      Icon(
                        Icons.check_box_outline_blank,
                        size: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Nije provjereno',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.check_box, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Imamo',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.check_box, size: 14, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'Treba kupiti',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addToShoppingList,
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Dodaj u listu za kupovinu'),
                    ),
                  ),

                  if (_steps.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Način pripreme',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ...(_steps.map(
                      (step) => StepRow(
                        step: step,
                        isDone: _completedSteps.contains(step.id),
                        onTap: () => setState(() {
                          if (_completedSteps.contains(step.id)) {
                            _completedSteps.remove(step.id);
                          } else {
                            _completedSteps.add(step.id!);
                          }
                        }),
                      ),
                    )),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
