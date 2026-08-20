import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audit_log_provider.dart';

class AuditStatsCards extends StatelessWidget {
  const AuditStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuditLogProvider>();
    final stats = provider.stats;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 1 : (width < 1000 ? 2 : 4);

    final cards = [
      _StatCard(
        value: stats.totalLogs.toString(),
        label: 'Total Logs',
        icon: Icons.show_chart,
        color: const Color(0xFF6D28D9),
      ),
      _StatCard(
        value: stats.employeeEvents.toString(),
        label: 'Employee Events',
        icon: Icons.person_outline,
        color: const Color(0xFF16A34A),
      ),
      _StatCard(
        value: stats.authEvents.toString(),
        label: 'Auth Events',
        icon: Icons.shield_outlined,
        color: const Color(0xFFCA8A04),
      ),
      _StatCard(
        value: stats.today.toString(),
        label: 'Today',
        icon: Icons.access_time,
        color: const Color(0xFFDC2626),
      ),
    ];

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: crossAxisCount == 1 ? 3.6 : 2.6,
      children: cards,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(label, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}