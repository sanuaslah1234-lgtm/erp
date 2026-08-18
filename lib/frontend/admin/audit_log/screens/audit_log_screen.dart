import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/audit_log_model.dart';
import '../providers/audit_log_provider.dart';
import '../widgets/audit_filters_bar.dart';
import '../widgets/audit_log_card_list.dart';
import '../widgets/audit_log_table.dart';
import '../widgets/audit_stats_cards.dart';
import 'employee_timeline_screen.dart';

/// Drop this into your app's routing / shell in place of the Audit Log
/// tab body. Wrap it (or a parent above it) with
/// ChangeNotifierProvider<AuditLogProvider> — see main.dart.
class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuditLogProvider>().fetchLogs();
    });
  }

  void _openTimeline(BuildContext context, AuditLogModel log) {
    if (log.employeeDbId == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EmployeeTimelineScreen(employeeDbId: log.employeeDbId!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuditLogProvider>();
    final isNarrow = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF6D28D9)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Audit Logs & Activity History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              OutlinedButton.icon(
                onPressed: provider.isLoading ? null : () => provider.fetchLogs(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Monitor real-time system events. Tap any log with a timeline button to see the full activity history.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 20),
          const AuditStatsCards(),
          const SizedBox(height: 20),
          const AuditFiltersBar(),
          const SizedBox(height: 20),
          _body(provider, isNarrow),
        ],
      ),
    );
  }

  Widget _body(AuditLogProvider provider, bool isNarrow) {
    if (provider.isLoading && provider.logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null && provider.logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.wifi_off_rounded, size: 44, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text('Could not load audit logs', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(provider.errorMessage!, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 14),
              OutlinedButton(onPressed: () => provider.fetchLogs(), child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (provider.logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined, size: 44, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              const Text('No logs found', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Try changing your filters.', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: isNarrow
          ? AuditLogCardList(logs: provider.logs, onViewTimeline: (log) => _openTimeline(context, log))
          : AuditLogTable(logs: provider.logs, onViewTimeline: (log) => _openTimeline(context, log)),
    );
  }
}