import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shopping_item.dart';
import '../services/shopping_service.dart';

final shoppingProvider =
    AsyncNotifierProvider<ShoppingNotifier, List<ShoppingItem>>(
      ShoppingNotifier.new,
    );

class ShoppingNotifier extends AsyncNotifier<List<ShoppingItem>> {
  @override
  Future<List<ShoppingItem>> build() async {
    return await ShoppingService.getItems();
  }

  Future<void> toggleItem(int id) async {
    final current = state.value ?? [];
    final item = current.firstWhere((i) => i.id == id);
    final newChecked = !item.isChecked;

    state = AsyncData(
      current
          .map((i) => i.id == id ? i.copyWith(isChecked: newChecked) : i)
          .toList(),
    );

    try {
      await ShoppingService.toggleItem(id, newChecked);
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    await ShoppingService.deleteItem(id);
    ref.invalidateSelf();
  }

  Future<void> deleteChecked() async {
    await ShoppingService.deleteChecked();
    ref.invalidateSelf();
  }

  Future<void> deleteAll() async {
    await ShoppingService.deleteAll();
    ref.invalidateSelf();
  }
}
