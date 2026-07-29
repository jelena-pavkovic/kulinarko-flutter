import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_card.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeGrid({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nema recepata. Dodaj prvi!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => RecipeCard(recipe: recipes[i]),
    );
  }
}
