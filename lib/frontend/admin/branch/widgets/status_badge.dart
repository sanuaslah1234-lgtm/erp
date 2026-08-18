import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;

  const StatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF16A34A) : const Color(0xFF6B7280);
    final bg = isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}