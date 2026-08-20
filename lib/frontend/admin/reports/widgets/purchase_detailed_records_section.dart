import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/purchase_record_model.dart';
import '../providers/purchase_reports_provider.dart';

class PurchaseDetailedRecordsSection extends StatelessWidget {
  const PurchaseDetailedRecordsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurchaseReportsProvider>();
    final records = provider.records;
    final isNarrow = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isNarrow
              ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('Detailed Records', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _searchBox(provider),
                ])
              : Row(children: [
                  const Text('Detailed Records', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SizedBox(width: 220, child: _searchBox(provider)),
                ]),
          const SizedBox(height: 20),
          if (provider.isLoading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator()))
          else if (records.isEmpty)
            _emptyState()
          else ...[
            _table(records),
            const SizedBox(height: 12),
            Text('Showing ${records.length} record${records.length == 1 ? '' : 's'}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _searchBox(PurchaseReportsProvider provider) {
    return TextField(
      onChanged: provider.setRecordsSearch,
      decoration: InputDecoration(
        hintText: 'Search records...',
        prefixIcon: const Icon(Icons.search, size: 20),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(children: [
        Icon(Icons.grid_view_rounded, size: 40, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        const Text('No Records Found', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Try modifying your filters or search keywords to display results.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ]),
    );
  }

  Widget _table(List<PurchaseRecordModel> records) {
    final headerStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                SizedBox(width: 110, child: Text('PO #', style: headerStyle)),
                Expanded(child: Text('SUPPLIER', style: headerStyle)),
                SizedBox(width: 90, child: Text('SUBTOTAL', style: headerStyle, textAlign: TextAlign.right)),
                SizedBox(width: 90, child: Text('TAX', style: headerStyle, textAlign: TextAlign.right)),
                SizedBox(width: 90, child: Text('TOTAL', style: headerStyle, textAlign: TextAlign.right)),
                SizedBox(width: 100, child: Text('STATUS', style: headerStyle)),
                SizedBox(width: 100, child: Text('DATE', style: headerStyle)),
              ]),
            ),
            const Divider(height: 1),
            ...records.map((r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(children: [
                    SizedBox(width: 110, child: Text(r.poNumber, style: const TextStyle(fontWeight: FontWeight.w600))),
                    Expanded(child: Text(r.supplierName)),
                    SizedBox(width: 90, child: Text('\$${r.subtotal.toStringAsFixed(2)}', textAlign: TextAlign.right)),
                    SizedBox(width: 90, child: Text('\$${r.tax.toStringAsFixed(2)}', textAlign: TextAlign.right)),
                    SizedBox(width: 90, child: Text('\$${r.total.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
                    SizedBox(width: 100, child: _StatusPill(status: r.status)),
                    SizedBox(
                      width: 100,
                      child: Text(
                        r.createdAt != null ? '${r.createdAt!.day.toString().padLeft(2, '0')}-${r.createdAt!.month.toString().padLeft(2, '0')}-${r.createdAt!.year}' : '-',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ),
                  ]),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'completed': color = const Color(0xFF16A34A); break;
      case 'pending': color = const Color(0xFFCA8A04); break;
      case 'cancelled': color = const Color(0xFFDC2626); break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status[0].toUpperCase() + status.substring(1), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}