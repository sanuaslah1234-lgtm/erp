import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/purchase_reports_provider.dart';

class SupplierFilterDropdown extends StatelessWidget {
  const SupplierFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurchaseReportsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter by Supplier', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: provider.suppliers.contains(provider.selectedSupplier)
                  ? provider.selectedSupplier
                  : 'All Suppliers',
              items: provider.suppliers.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (value) {
                if (value != null) provider.setSupplier(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}