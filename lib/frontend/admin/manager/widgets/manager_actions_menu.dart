import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/manager_model.dart';
import '../providers/manager_provider.dart';
import 'manager_form_dialog.dart';

class ManagerActionsMenu extends StatelessWidget {
  final ManagerModel manager;

  const ManagerActionsMenu({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        if (value == 'edit') {
          showDialog(
            context: context,
            builder: (_) => ManagerFormDialog(existingManager: manager),
          );
        } else if (value == 'delete') {
          _confirmDelete(context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'edit',
          child: Row(children: [
            Icon(Icons.edit_outlined, size: 18),
            SizedBox(width: 10),
            Text('Edit'),
          ]),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            Icon(Icons.delete_outline, size: 18, color: Colors.red),
            SizedBox(width: 10),
            Text('Delete', style: TextStyle(color: Colors.red)),
          ]),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    final provider = context.read<ManagerProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Manager'),
        content: Text(
          'Are you sure you want to delete "${manager.fullName}" (${manager.employeeId})? '
          'This will remove their login access. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.deleteManager(manager.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Manager deleted successfully'
                          : provider.errorMessage ?? 'Failed to delete manager',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}