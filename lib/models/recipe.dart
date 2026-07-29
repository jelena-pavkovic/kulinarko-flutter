import 'recipe_ingredient.dart';
import 'step.dart';

class Recipe {
  final int? id;
  final int? categoryId;
  final String name;
  final String? description;
  final int? prepTimeMin;
  final int? servings;
  final List<RecipeIngredient>? ingredients;
  final List<RecipeStep>? steps;

  Recipe({
    this.id,
    this.categoryId,
    required this.name,
    this.description,
    this.prepTimeMin,
    this.servings,
    this.ingredients,
    this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      prepTimeMin: json['prep_time_min'],
      servings: json['servings'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map((i) => RecipeIngredient.fromJson(i))
                .toList()
          : null,
      steps: json['steps'] != null
          ? (json['steps'] as List).map((s) => RecipeStep.fromJson(s)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'name': name,
    'description': description,
    'prep_time_min': prepTimeMin,
    'servings': servings,
    if (ingredients != null)
      'ingredients': ingredients!.map((i) => i.toJson()).toList(),
    if (steps != null) 'steps': steps!.map((s) => s.toJson()).toList(),
  };
}
