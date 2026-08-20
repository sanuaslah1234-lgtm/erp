import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_reports_provider.dart';

class InventoryFiltersBar extends StatelessWidget {
  const InventoryFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryReportsProvider>();
    final isNarrow = MediaQuery.of(context).size.width < 700;

    final categoryDropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: provider.categories.contains(provider.selectedCategory) ? provider.selectedCategory : 'All Categories',
          items: provider.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) {
            if (v != null) provider.setCategory(v);
          },
        ),
      ),
    );

    final searchField = TextField(
      onChanged: provider.setRecordsSearch,
      decoration: InputDecoration(
        hintText: 'Search by SKU or item name...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );

    if (isNarrow) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [searchField, const SizedBox(height: 10), categoryDropdown]);
    }

    return Row(children: [
      Expanded(flex: 2, child: searchField),
      const SizedBox(width: 12),
      Expanded(child: categoryDropdown),
    ]);
  }
}