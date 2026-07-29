import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shopping_provider.dart';
import '../widgets/shopping_item_tile.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  Future<void> _runWithLoadingDialog(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Brisanje...'),
          ],
        ),
      ),
    );

    try {
      await action();
    } finally {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingAsync = ref.watch(shoppingProvider);

    return Scaffold(
      appBar: AppBar(
        title: shoppingAsync.when(
          loading: () => const Text('Lista za kupovinu'),
          error: (_, _) => const Text('Lista za kupovinu'),
          data: (items) => Text('Lista za kupovinu (${items.length})'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_done_outlined),
            tooltip: 'Obriši kupljene',
            onPressed: () async {
              try {
                await _runWithLoadingDialog(
                  context,
                  () => ref.read(shoppingProvider.notifier).deleteChecked(),
                );
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Greška pri brisanju.')),
                  );
                }
              }
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Obriši sve',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Obriši cijelu listu'),
                  content: const Text(
                    'Da li si sigurna? Ova akcija se ne može poništiti.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Otkaži'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Obriši sve'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  await _runWithLoadingDialog(
                    context,
                    () => ref.read(shoppingProvider.notifier).deleteAll(),
                  );
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Greška pri brisanju.')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),

      body: shoppingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('Nije moguće učitati listu.'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(shoppingProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Pokušaj ponovo'),
              ),
            ],
          ),
        ),

        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lista je prazna.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Označi sastojke crvenom bojom u receptu\ni tapni "Dodaj u listu za kupovinu".',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final unchecked = items.where((i) => !i.isChecked).toList();
          final checked = items.where((i) => i.isChecked).toList();
          final sorted = [...unchecked, ...checked];

          return ListView.separated(
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = sorted[index];
              return ShoppingItemTile(
                item: item,
                onToggle: () async {
                  try {
                    await ref
                        .read(shoppingProvider.notifier)
                        .toggleItem(item.id!);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Greška pri ažuriranju.')),
                      );
                    }
                  }
                },
                onDelete: () async {
                  try {
                    await ref
                        .read(shoppingProvider.notifier)
                        .deleteItem(item.id!);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Greška pri brisanju.')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
