import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/manager_provider.dart';
import 'manager_form_dialog.dart';

class ManagerToolbar extends StatelessWidget {
  const ManagerToolbar({super.key});

  String _sortLabel(ManagerSort s) {
    switch (s) {
      case ManagerSort.defaultOrder:
        return 'Sort (default)';
      case ManagerSort.nameAZ:
        return 'Name (A-Z)';
      case ManagerSort.nameZA:
        return 'Name (Z-A)';
      case ManagerSort.newest:
        return 'Newest';
      case ManagerSort.oldest:
        return 'Oldest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManagerProvider>();
    final isNarrow = MediaQuery.of(context).size.width < 700;

    final searchField = TextField(
      onChanged: provider.setSearchQuery,
      decoration: InputDecoration(
        hintText: 'Search managers...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );

    final sortDropdown = DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<ManagerSort>(
          value: provider.sortOption,
          icon: const Icon(Icons.arrow_drop_down),
          items: ManagerSort.values
              .map((s) => DropdownMenuItem(value: s, child: Text(_sortLabel(s))))
              .toList(),
          onChanged: (value) {
            if (value != null) provider.setSort(value);
          },
        ),
      ),
    );

    final refreshButton = OutlinedButton(
      onPressed: provider.isLoading ? null : () => provider.fetchManagers(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: provider.isLoading
          ? const SizedBox(
              width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.refresh, size: 20),
    );

    final addButton = FilledButton.icon(
      onPressed: () => showDialog(context: context, builder: (_) => const ManagerFormDialog()),
      icon: const Icon(Icons.person_add_alt_1, size: 18),
      label: const Text('Add Manager'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          const SizedBox(height: 10),
          Row(children: [Expanded(child: sortDropdown), const SizedBox(width: 10), refreshButton]),
          const SizedBox(height: 10),
          addButton,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: searchField),
        const SizedBox(width: 12),
        sortDropdown,
        const SizedBox(width: 12),
        refreshButton,
        const SizedBox(width: 12),
        addButton,
      ],
    );
  }
}