class RecipeIngredient {
  final int? id;
  final int? recipeId;
  final int? ingredientId;
  final String name;
  final double quantity;
  final String unit;
  final String? notes;

  RecipeIngredient({
    this.id,
    this.recipeId,
    this.ingredientId,
    required this.name,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'],
      recipeId: json['recipe_id'],
      ingredientId: json['ingredient_id'],
      name: json['name'] ?? json['ingredient_name'] ?? '',
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ingredient_id': ingredientId,
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'notes': notes,
  };
}
