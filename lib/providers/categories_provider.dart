import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/category_service.dart';

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<Category>>(
      CategoriesNotifier.new,
    );

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    return await CategoryService.getAllCategories();
  }

  Future<void> addCategory(Category category) async {
    await CategoryService.insertCategory(category);
    ref.invalidateSelf();
  }

  Future<void> updateCategory(Category category) async {
    await CategoryService.updateCategory(category);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(int id) async {
    await CategoryService.deleteCategory(id);
    ref.invalidateSelf();
  }
}
