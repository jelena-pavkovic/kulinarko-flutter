import '../models/category.dart';
import 'api_service.dart';

class CategoryService {
  static Future<List<Category>> getAllCategories() async {
    final data = await ApiService.get('/categories');
    return (data as List).map((json) => Category.fromJson(json)).toList();
  }

  static Future<int> insertCategory(Category category) async {
    final data = await ApiService.post('/categories', category.toJson());
    return data['id'];
  }

  static Future<void> updateCategory(Category category) async {
    await ApiService.put('/categories/${category.id}', category.toJson());
  }

  static Future<void> deleteCategory(int id) async {
    await ApiService.delete('/categories/$id');
  }
}
