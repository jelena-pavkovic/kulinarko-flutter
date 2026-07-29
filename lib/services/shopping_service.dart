import '../models/shopping_item.dart';
import 'api_service.dart';

class ShoppingService {
  static Future<List<ShoppingItem>> getItems() async {
    final data = await ApiService.get('/shopping');
    return (data as List).map((json) => ShoppingItem.fromJson(json)).toList();
  }

  static Future<void> addItem({
    required String name,
    required double quantity,
    required String unit,
  }) async {
    await ApiService.post('/shopping/items', {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    });
  }

  static Future<void> toggleItem(int id, bool isChecked) async {
    await ApiService.put('/shopping/items/$id', {'is_checked': isChecked});
  }

  static Future<void> deleteItem(int id) async {
    await ApiService.delete('/shopping/items/$id');
  }

  static Future<void> deleteChecked() async {
    await ApiService.delete('/shopping/checked');
  }

  static Future<void> deleteAll() async {
    await ApiService.delete('/shopping/all');
  }
}
