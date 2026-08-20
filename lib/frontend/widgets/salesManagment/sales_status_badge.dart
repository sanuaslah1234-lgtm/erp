import 'package:flutter/material.dart';

import 'package:erp_software/theme/app_colors.dart';

class SalesStatusBadge extends StatelessWidget {
  final String status;

  const SalesStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid =
        status.toLowerCase() == 'paid';

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isPaid
            ? Colors.green.withOpacity(0.10)
            : Colors.red.withOpacity(0.10),
        borderRadius:
            BorderRadius.circular(7),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isPaid
              ? Colors.green.shade700
              : Colors.red.shade700,
        ),
      ),
    );
  }
}