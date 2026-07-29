import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryChipBar extends StatelessWidget {
  final List<Category> categories;
  final int? selectedId; // null = "Sve"
  final ValueChanged<int?> onSelected;

  const CategoryChipBar({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Sve'),
              selected: selectedId == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text('${cat.icon ?? ''} ${cat.name}'),
                selected: selectedId == cat.id,
                onSelected: (_) => onSelected(cat.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
