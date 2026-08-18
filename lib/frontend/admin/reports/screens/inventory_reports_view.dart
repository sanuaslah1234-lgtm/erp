import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_reports_provider.dart';
import '../widgets/inventory_detailed_records_section.dart';
import '../widgets/inventory_filters_bar.dart';
import '../widgets/inventory_summary_cards.dart';

class InventoryReportsView extends StatefulWidget {
  const InventoryReportsView({super.key});

  @override
  State<InventoryReportsView> createState() => _InventoryReportsViewState();
}

class _InventoryReportsViewState extends State<InventoryReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryReportsProvider>().initIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryReportsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
          child: const InventoryFiltersBar(),
        ),
        const SizedBox(height: 20),
        if (provider.errorMessage != null && provider.summary.totalItems == 0)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFECACA))),
            child: Row(children: [
              const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(provider.errorMessage!, style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13))),
              TextButton(onPressed: () => provider.fetchReport(), child: const Text('Retry')),
            ]),
          ),
        const InventorySummaryCards(),
        const SizedBox(height: 20),
        const InventoryDetailedRecordsSection(),
      ],
    );
  }
}