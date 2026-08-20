import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inventory_record_model.dart';
import '../providers/inventory_reports_provider.dart';

class InventoryDetailedRecordsSection extends StatelessWidget {
  const InventoryDetailedRecordsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryReportsProvider>();
    final records = provider.records;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Inventory Records', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (provider.isLoading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator()))
          else if (records.isEmpty)
            _emptyState()
          else ...[
            _table(records),
            const SizedBox(height: 12),
            Text('Showing ${records.length} item${records.length == 1 ? '' : 's'}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(children: [
        Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        const Text('No Items Found', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Try a different category or search term.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ]),
    );
  }

  Widget _table(List<InventoryRecordModel> records) {
    final headerStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                SizedBox(width: 90, child: Text('SKU', style: headerStyle)),
                Expanded(flex: 2, child: Text('ITEM', style: headerStyle)),
                SizedBox(width: 110, child: Text('CATEGORY', style: headerStyle)),
                SizedBox(width: 70, child: Text('QTY', style: headerStyle, textAlign: TextAlign.right)),
                SizedBox(width: 90, child: Text('UNIT COST', style: headerStyle, textAlign: TextAlign.right)),
                SizedBox(width: 100, child: Text('TOTAL VALUE', style: headerStyle, textAlign: TextAlign.right)),
                SizedBox(width: 90, child: Text('STATUS', style: headerStyle)),
              ]),
            ),
            const Divider(height: 1),
            ...records.map((r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(children: [
                    SizedBox(width: 90, child: Text(r.sku, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5))),
                    Expanded(flex: 2, child: Text(r.itemName)),
                    SizedBox(width: 110, child: Text(r.category, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600))),
                    SizedBox(width: 70, child: Text(r.quantityInStock.toString(), textAlign: TextAlign.right)),
                    SizedBox(width: 90, child: Text('\$${r.unitCost.toStringAsFixed(2)}', textAlign: TextAlign.right)),
                    SizedBox(width: 100, child: Text('\$${r.totalValue.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
                    SizedBox(width: 90, child: _StockStatusPill(status: r.stockStatus)),
                  ]),
                )),
          ],
        ),
      ),
    );
  }
}

class _StockStatusPill extends StatelessWidget {
  final String status; // out | low | ok
  const _StockStatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    switch (status) {
      case 'out':
        color = const Color(0xFFDC2626);
        label = 'Out of Stock';
        break;
      case 'low':
        color = const Color(0xFFCA8A04);
        label = 'Low Stock';
        break;
      default:
        color = const Color(0xFF16A34A);
        label = 'In Stock';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w600)),
    );
  }
}