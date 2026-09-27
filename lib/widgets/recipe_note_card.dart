import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../app.dart';

class RecipeNoteCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeNoteCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final details = [
      if (recipe.prepTimeMin != null) '${recipe.prepTimeMin} min',
      if (recipe.servings != null) '${recipe.servings} porcija',
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: kCardBorder,
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kTerracotta.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '📝',
                    style: TextStyle(fontSize: 26),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: kInk,
                        ),
                      ),

                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Text(
                          details,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kMutedText,
                          ),
                        ),
                      ],

                      if (recipe.description != null &&
                          recipe.description!.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          recipe.description!.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: kMutedText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.chevron_right,
                  color: kMutedText,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
