import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app.dart';
import '../providers/recipes_provider.dart';
import '../providers/categories_provider.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  int? _selectedCategoryId;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Dobro jutro 👋';
    if (hour < 18) return 'Dobar dan 👋';
    return 'Dobro veče 👋';
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting,
                          style: const TextStyle(
                            fontSize: 14,
                            color: kAccentDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Šta kuvamo danas?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: kInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: kAccent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => context.push('/recipe/new'),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Pretraži recepte...',
                  prefixIcon: Icon(Icons.search, color: kAccentDark),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

            categoriesAsync.when(
              loading: () => const SizedBox(height: 44),
              error: (_, _) => const SizedBox(height: 44),
              data: (categories) => CategoryChipBar(
                categories: categories,
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              child: recipesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 48, color: kAccentLight),
                      const SizedBox(height: 12),
                      const Text(
                        'Nije moguće učitati recepte.',
                        style: TextStyle(color: kInk),
                      ),
                      Text(
                        'Provjerite internet konekciju.',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(recipesProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Pokušaj ponovo'),
                      ),
                    ],
                  ),
                ),
                data: (recipes) {
                  var filtered = recipes.where((r) {
                    final matchesSearch =
                        _searchQuery.isEmpty ||
                        r.name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                    final matchesCategory =
                        _selectedCategoryId == null ||
                        r.categoryId == _selectedCategoryId;
                    return matchesSearch && matchesCategory;
                  }).toList();

                  return RecipeGrid(recipes: filtered);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
