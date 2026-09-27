import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/shopping_item.dart';
import '../app.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: kDanger,
            foregroundColor: const Color(0xFF2B1014),
            icon: Icons.delete,
            label: 'Obriši',
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isChecked,
          onChanged: (_) => onToggle(),
          activeColor: kSuccess,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isChecked ? TextDecoration.lineThrough : null,
            color: item.isChecked ? kMutedText : null,
          ),
        ),
        trailing: Text(
          '${item.quantity} ${item.unit}',
          style: TextStyle(
            color: item.isChecked ? kMutedText : kInk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
