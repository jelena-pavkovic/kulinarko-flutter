import '../models/recipe.dart';
import 'api_service.dart';

class RecipeService {
  static Future<List<Recipe>> getAllRecipes() async {
    final data = await ApiService.get('/recipes');
    return (data as List).map((json) => Recipe.fromJson(json)).toList();
  }

  static Future<Recipe> getRecipe(int id) async {
    final data = await ApiService.get('/recipes/$id');
    return Recipe.fromJson(data);
  }

  static Future<List<Recipe>> search(String query) async {
    final data = await ApiService.get('/recipes/search?q=$query');
    return (data as List).map((json) => Recipe.fromJson(json)).toList();
  }

  static Future<int> insertRecipe(Recipe recipe) async {
    final data = await ApiService.post('/recipes', recipe.toJson());
    return data['id'];
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    await ApiService.put('/recipes/${recipe.id}', recipe.toJson());
  }

  static Future<void> deleteRecipe(int id) async {
    await ApiService.delete('/recipes/$id');
  }
}
