import 'package:flutter/material.dart';

import '../models/audit_log_model.dart';
import 'action_badge.dart';

class AuditLogCardList extends StatelessWidget {
  final List<AuditLogModel> logs;
  final void Function(AuditLogModel log) onViewTimeline;

  const AuditLogCardList({super.key, required this.logs, required this.onViewTimeline});

  String _dateLabel(DateTime? dt) {
    if (dt == null) return '-';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day} at $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final log = logs[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(log.employeeName ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ActionBadge(action: log.action),
                ],
              ),
              const SizedBox(height: 4),
              Text(_dateLabel(log.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                  child: Text(log.module, style: const TextStyle(fontSize: 11.5)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(log.description, style: const TextStyle(fontSize: 13))),
              ]),
              if (log.employeeDbId != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () => onViewTimeline(log),
                    icon: const Icon(Icons.timeline, size: 14),
                    label: const Text('View Timeline', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}