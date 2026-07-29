class RecipeStep {
  final int? id;
  final int? recipeId;
  final int orderNum;
  final String description;

  RecipeStep({
    this.id,
    this.recipeId,
    required this.orderNum,
    required this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: json['id'],
      recipeId: json['recipe_id'],
      orderNum: json['order_num'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'order_num': orderNum,
    'description': description,
  };
}
