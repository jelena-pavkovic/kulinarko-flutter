import 'package:flutter/material.dart';
import '../models/recipe_ingredient.dart';
import '../app.dart';

enum IngredientState { unchecked, haveIt, needToBuy }

class IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;
  final IngredientState state;
  final VoidCallback onTap;

  const IngredientRow({
    super.key,
    required this.ingredient,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      decoration: state == IngredientState.haveIt
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      color: state == IngredientState.haveIt ? Colors.grey : null,
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: GestureDetector(onTap: onTap, child: _buildCheckbox()),
      title: Text(ingredient.name, style: textStyle),
      subtitle: ingredient.notes != null
          ? Text(ingredient.notes!, style: const TextStyle(fontSize: 12))
          : null,
      trailing: Text(
        '${ingredient.quantity} ${ingredient.unit}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCheckbox() {
    switch (state) {
      case IngredientState.unchecked:
        return const Icon(Icons.check_box_outline_blank, color: kMutedText);
      case IngredientState.haveIt:
        return const Icon(Icons.check_box, color: kSuccess);
      case IngredientState.needToBuy:
        return const Icon(Icons.check_box, color: kDanger);
    }
  }
}
