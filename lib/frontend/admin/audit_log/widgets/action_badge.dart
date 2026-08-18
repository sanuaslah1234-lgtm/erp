import 'package:flutter/material.dart';

class ActionBadge extends StatelessWidget {
  final String action;

  const ActionBadge({super.key, required this.action});

  static Color colorFor(String action) {
    switch (action) {
      case 'LOGIN':
        return const Color(0xFF7C3AED);
      case 'LOGOUT':
        return Colors.grey;
      case 'CREATE':
        return const Color(0xFF16A34A);
      case 'UPDATE':
        return const Color(0xFF2563EB);
      case 'DELETE':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  static IconData iconFor(String action) {
    switch (action) {
      case 'LOGIN':
        return Icons.login;
      case 'LOGOUT':
        return Icons.logout;
      case 'CREATE':
        return Icons.add_circle_outline;
      case 'UPDATE':
        return Icons.edit_outlined;
      case 'DELETE':
        return Icons.delete_outline;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(action);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        action,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}