import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports_provider.dart';

class CustomerFilterDropdown extends StatelessWidget {
  const CustomerFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter by Customer', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
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
              value: provider.customers.contains(provider.selectedCustomer)
                  ? provider.selectedCustomer
                  : 'All Customers',
              items: provider.customers
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) provider.setCustomer(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}