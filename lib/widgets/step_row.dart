import 'package:flutter/material.dart';
import '../models/step.dart' as model;

class StepRow extends StatelessWidget {
  final model.RecipeStep step;
  final bool isDone;
  final VoidCallback onTap;

  const StepRow({
    super.key,
    required this.step,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Broj koraka ili checkmark
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                        '${step.orderNum}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                step.description,
                style: TextStyle(
                  fontSize: 15,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
