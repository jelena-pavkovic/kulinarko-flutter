import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

final recipesProvider = AsyncNotifierProvider<RecipesNotifier, List<Recipe>>(
  RecipesNotifier.new,
);

class RecipesNotifier extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    return await RecipeService.getAllRecipes();
  }

  // Vraća ID novog recepta
  Future<int> addRecipe(Recipe recipe) async {
    final id = await RecipeService.insertRecipe(recipe);
    ref.invalidateSelf();
    return id;
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await RecipeService.updateRecipe(recipe);
    ref.invalidateSelf();
  }

  Future<void> deleteRecipe(int id) async {
    await RecipeService.deleteRecipe(id);
    ref.invalidateSelf();
  }
}
