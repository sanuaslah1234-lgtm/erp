import 'package:flutter/material.dart';

class CustomerSelector extends StatelessWidget {
  final String currentCustomer;
  final ValueChanged<String> onCustomerSelected;

  const CustomerSelector({
    super.key,
    required this.currentCustomer,
    required this.onCustomerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                currentCustomer,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          InkWell(
            onTap: () => _showCustomerDialog(context),
            child: const Text(
              'Change',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerDialog(BuildContext context) {
    final controller = TextEditingController(text: currentCustomer);
    final sampleCustomers = ['Walk-in Customer', 'John Doe (Regular)', 'Ahmed Al-Mansoor', 'TechCorp Inc.'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Customer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Customer Name / Phone'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sampleCustomers.map((c) {
                return ChoiceChip(
                  label: Text(c, style: const TextStyle(fontSize: 11)),
                  selected: controller.text == c,
                  onSelected: (_) {
                    controller.text = c;
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              onCustomerSelected(controller.text.trim().isEmpty ? 'Walk-in Customer' : controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
