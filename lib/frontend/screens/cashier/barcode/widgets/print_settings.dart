import 'package:flutter/material.dart';

class PrintSettingsWidget extends StatelessWidget {
  final int labelCount;
  final String paperSize;
  final ValueChanged<String> onPaperSizeChanged;

  const PrintSettingsWidget({
    super.key,
    required this.labelCount,
    required this.paperSize,
    required this.onPaperSizeChanged,
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
          const Text('Label Print Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Labels to Print:'),
              Text('$labelCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4F46E5))),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: paperSize,
            decoration: const InputDecoration(labelText: 'Label Size / Roll'),
            items: const [
              DropdownMenuItem(value: '50mm x 30mm (Standard Roll)', child: Text('50mm x 30mm (Standard Roll)')),
              DropdownMenuItem(value: '40mm x 25mm (Compact)', child: Text('40mm x 25mm (Compact)')),
              DropdownMenuItem(value: 'A4 Sheet (24 Labels/Page)', child: Text('A4 Sheet (24 Labels/Page)')),
            ],
            onChanged: (val) => onPaperSizeChanged(val ?? paperSize),
          ),
        ],
      ),
    );
  }
}
