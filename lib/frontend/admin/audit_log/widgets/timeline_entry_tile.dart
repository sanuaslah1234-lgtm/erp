import 'package:flutter/material.dart';

import '../models/audit_log_model.dart';
import 'action_badge.dart';

class TimelineEntryTile extends StatelessWidget {
  final AuditLogModel entry;

  const TimelineEntryTile({super.key, required this.entry});

  String _time(DateTime? dt) {
    if (dt == null) return '';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final color = ActionBadge.colorFor(entry.action);
    final icon = ActionBadge.iconFor(entry.action);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.action.substring(0, 1) + entry.action.substring(1).toLowerCase(),
                        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(entry.description, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('IP: ${entry.ipAddress}',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Text(_time(entry.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}