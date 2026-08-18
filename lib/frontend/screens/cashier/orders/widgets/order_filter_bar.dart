import 'package:flutter/material.dart';

class OrderFilterBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onPaymentMethodChanged;
  final String selectedStatus;
  final String selectedPaymentMethod;

  const OrderFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onPaymentMethodChanged,
    required this.selectedStatus,
    required this.selectedPaymentMethod,
  });

  @override
  State<OrderFilterBar> createState() => _OrderFilterBarState();
}

class _OrderFilterBarState extends State<OrderFilterBar> {
  String _selectedCustomer = 'All Customers';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Search Invoice Input
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 38,
            child: TextField(
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search Invoice...',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 2. All Customers Dropdown
        Expanded(
          flex: 4,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCustomer,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
                items: const [
                  DropdownMenuItem(value: 'All Customers', child: Text('All Customers')),
                  DropdownMenuItem(value: 'Walk-in Customer', child: Text('Walk-in Customer')),
                  DropdownMenuItem(value: 'Regular Customer', child: Text('Regular Customer')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCustomer = val);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 3. All Payments Dropdown
        Expanded(
          flex: 4,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.selectedPaymentMethod,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Payments')),
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Card', child: Text('Card')),
                  DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                  DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
                ],
                onChanged: (val) => widget.onPaymentMethodChanged(val ?? 'all'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

