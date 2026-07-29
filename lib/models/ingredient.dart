class Ingredient {
  final int? id;
  final String name;
  final String? defaultUnit;
  final double? pricePerUnit;

  Ingredient({
    this.id,
    required this.name,
    this.defaultUnit,
    this.pricePerUnit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      defaultUnit: json['default_unit'],
      pricePerUnit: json['price_per_unit'] != null
          ? double.parse(json['price_per_unit'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'default_unit': defaultUnit,
      'price_per_unit': pricePerUnit,
    };
  }
}
