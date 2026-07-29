import 'package:kulinarko/models/ingredient.dart';
import 'package:kulinarko/services/api_service.dart';

class IngredientService {
  static Future<List<Ingredient>> getAllIngredients() async {
    final data = await ApiService.get('/ingredients');
    return (data as List).map((json) => Ingredient.fromJson(json)).toList();
  }

  static Future<int> insertIngredient(Ingredient ingredient) async {
    final data = await ApiService.post('/ingredients', ingredient.toJson());
    return data['id'];
  }

  static Future<void> updateIngredient(Ingredient ingredient) async {
    await ApiService.put('/ingredients/${ingredient.id}', ingredient.toJson());
  }
}
