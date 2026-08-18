import 'package:flutter/material.dart';

class RefundSummaryWidget extends StatelessWidget {
  final double calculatedTotal;
  final String refundMethod;
  final String reason;
  final ValueChanged<String> onMethodChanged;
  final ValueChanged<String> onReasonChanged;
  final VoidCallback onSubmitRefund;
  final bool isLoading;

  const RefundSummaryWidget({
    super.key,
    required this.calculatedTotal,
    required this.refundMethod,
    required this.reason,
    required this.onMethodChanged,
    required this.onReasonChanged,
    required this.onSubmitRefund,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Refund Confirmation Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Refund Amount:'),
              Text('\$${calculatedTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.purple)),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: refundMethod,
            decoration: const InputDecoration(labelText: 'Refund Method'),
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Card', child: Text('Card / Original Payment')),
              DropdownMenuItem(value: 'Store Credit', child: Text('Store Credit')),
            ],
            onChanged: (val) => onMethodChanged(val ?? 'Cash'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: reason,
            onChanged: onReasonChanged,
            decoration: const InputDecoration(labelText: 'Reason for Refund'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: calculatedTotal > 0 && !isLoading ? onSubmitRefund : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
              icon: isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.replay),
              label: const Text('Process Refund & Restore Stock', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
