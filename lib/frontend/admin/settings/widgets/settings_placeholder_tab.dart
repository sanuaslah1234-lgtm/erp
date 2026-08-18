import 'package:flutter/material.dart';

class SettingsPlaceholderTab extends StatelessWidget {
  final String title;

  const SettingsPlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_outlined, size: 42, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text('$title settings coming soon',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
            Text('This section will be built once its fields are designed.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}