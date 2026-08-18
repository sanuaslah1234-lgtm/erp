import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import 'branch_form_dialog.dart';

class BranchActionsMenu extends StatelessWidget {
  final BranchModel branch;

  const BranchActionsMenu({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        if (value == 'edit') {
          showDialog(
            context: context,
            builder: (_) => BranchFormDialog(existingBranch: branch),
          );
        } else if (value == 'delete') {
          _confirmDelete(context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 10),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
              SizedBox(width: 10),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    final provider = context.read<BranchProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Branch'),
        content: Text(
          'Are you sure you want to delete "${branch.name}" (${branch.code})? '
          'This action cannot be undone.',
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
              final success = await provider.deleteBranch(branch.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Branch deleted successfully'
                          : provider.errorMessage ?? 'Failed to delete branch',
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