import 'package:flutter/material.dart';

import '../models/audit_log_model.dart';
import 'action_badge.dart';

class AuditLogTable extends StatelessWidget {
  final List<AuditLogModel> logs;
  final void Function(AuditLogModel log) onViewTimeline;

  const AuditLogTable({super.key, required this.logs, required this.onViewTimeline});

  String _relativeTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _dateLabel(DateTime? dt) {
    if (dt == null) return '-';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                SizedBox(width: 150, child: Text('DATE & TIME', style: headerStyle)),
                Expanded(flex: 3, child: Text('EMPLOYEE', style: headerStyle)),
                SizedBox(width: 90, child: Text('ACTION', style: headerStyle)),
                SizedBox(width: 100, child: Text('MODULE', style: headerStyle)),
                Expanded(flex: 3, child: Text('DESCRIPTION', style: headerStyle)),
                SizedBox(width: 130, child: Text('TIMELINE', style: headerStyle)),
              ]),
            ),
            const Divider(height: 1),
            ...logs.map((log) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_dateLabel(log.createdAt), style: const TextStyle(fontSize: 12.5)),
                            Text('(${_relativeTime(log.createdAt)})',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: const Color(0xFF6D28D9),
                              child: Text(
                                (log.employeeName?.isNotEmpty ?? false)
                                    ? log.employeeName![0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(log.employeeName ?? 'Unknown',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis),
                                  Text(log.employeeEmail ?? '',
                                      style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                                      overflow: TextOverflow.ellipsis),
                                  if (log.employeeId != null)
                                    Text('ID: ${log.employeeId}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 90, child: ActionBadge(action: log.action)),
                      SizedBox(
                        width: 100,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(log.module, style: const TextStyle(fontSize: 11.5)),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(children: [
                          Icon(Icons.arrow_forward, size: 13, color: Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(log.description,
                                style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: 130,
                        child: log.employeeDbId == null
                            ? const SizedBox.shrink()
                            : OutlinedButton.icon(
                                onPressed: () => onViewTimeline(log),
                                icon: const Icon(Icons.timeline, size: 14),
                                label: const Text('View', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                              ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}