import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/recipe.dart';
import 'recipe_note_card.dart';
import '../app.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeGrid({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 72,
              color: kMutedText,
            ),
            SizedBox(height: 16),
            Text(
              'Nema recepata. Dodaj prvi!',
              style: TextStyle(
                fontSize: 16,
                color: kMutedText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 16,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];

        return RecipeNoteCard(
          recipe: recipe,
          onTap: () => context.push('/recipe/${recipe.id}'),
        );
      },
    );
  }
}


/*import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_card.dart';
import 'recipe_note_card.dart';
import 'package:go_router/go_router.dart';

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
      itemBuilder: (context, i) => RecipeNoteCard(
        recipe: recipes[i],
        onTap: () => context.push('/recipe/${recipes[i].id}'),
      ),
    );
  }
}*/
