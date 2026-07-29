import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/categories_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Postavke')),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Kategorije',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          categoriesAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => const ListTile(
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Greška pri učitavanju kategorija.'),
            ),
            data: (categories) => Column(
              children: [
                ...categories.map(
                  (cat) => ListTile(
                    leading: Text(
                      cat.icon ?? '🍽️',
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(cat.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () =>
                              _showCategoryDialog(context, ref, existing: cat),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _confirmDelete(context, ref, cat),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Dodaj kategoriju'),
            onTap: () => _showCategoryDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    Category? existing,
  }) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final iconController = TextEditingController(text: existing?.icon ?? '');

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(existing == null ? 'Nova kategorija' : 'Uredi kategoriju'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Naziv *',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: iconController,
              decoration: const InputDecoration(
                labelText: 'Emoji ikona (opciono)',
                hintText: '🍲',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Otkaži'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              final cat = Category(
                id: existing?.id,
                name: nameController.text.trim(),
                icon: iconController.text.trim().isEmpty
                    ? null
                    : iconController.text.trim(),
              );
              try {
                if (existing == null) {
                  await ref.read(categoriesProvider.notifier).addCategory(cat);
                } else {
                  await ref
                      .read(categoriesProvider.notifier)
                      .updateCategory(cat);
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } catch (e) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Greška pri čuvanju kategorije.'),
                    ),
                  );
                }
              }
            },
            child: const Text('Sačuvaj'),
          ),
        ],
      ),
    );

    nameController.dispose();
    iconController.dispose();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Category cat,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Obriši kategoriju'),
        content: Text(
          'Obrisati "${cat.name}"?\n\nRecepti koji koriste ovu kategoriju neće biti obrisani.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Obriši'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(categoriesProvider.notifier).deleteCategory(cat.id!);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Greška pri brisanju kategorije.')),
          );
        }
      }
    }
  }
}
