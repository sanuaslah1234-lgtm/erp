import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_reports_provider.dart';

class InventorySummaryCards extends StatelessWidget {
  const InventorySummaryCards({super.key});

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final summary = context.watch<InventoryReportsProvider>().summary;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 1 : (width < 1000 ? 2 : 4);

    final cards = [
      _StatCard(label: 'TOTAL STOCK VALUE', value: _money(summary.totalStockValue), subtitle: 'Current inventory worth',
          icon: Icons.inventory_2_outlined, color: const Color(0xFF2563EB)),
      _StatCard(label: 'TOTAL ITEMS', value: summary.totalItems.toString(), subtitle: 'Distinct SKUs',
          icon: Icons.category_outlined, color: const Color(0xFF16A34A)),
      _StatCard(label: 'LOW STOCK', value: summary.lowStock.toString(), subtitle: 'At or below reorder level',
          icon: Icons.warning_amber_rounded, color: const Color(0xFFCA8A04)),
      _StatCard(label: 'OUT OF STOCK', value: summary.outOfStock.toString(), subtitle: 'Zero quantity',
          icon: Icons.remove_shopping_cart_outlined, color: const Color(0xFFDC2626)),
    ];

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: crossAxisCount == 1 ? 3.2 : 2.4,
      children: cards,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.subtitle, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}