class ShoppingItem {
  final int? id;
  final int? shoppingListId;
  final String name;
  final double quantity;
  final String unit;
  final bool isChecked;

  ShoppingItem({
    this.id,
    this.shoppingListId,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isChecked = false,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      shoppingListId: json['shopping_list_id'],
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] ?? '',
      isChecked: json['is_checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'is_checked': isChecked,
  };

  ShoppingItem copyWith({bool? isChecked}) => ShoppingItem(
    id: id,
    shoppingListId: shoppingListId,
    name: name,
    quantity: quantity,
    unit: unit,
    isChecked: isChecked ?? this.isChecked,
  );
}
