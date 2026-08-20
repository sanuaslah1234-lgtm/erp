import 'package:flutter/material.dart';
import 'package:erp_software/frontend/models/cashier/pos_order.dart';

class RefundItemSelector extends StatelessWidget {
  final PosOrder order;
  final Map<int, double> refundQuantities;
  final Function(int itemKey, double qty, double maxQty) onQuantityChanged;

  const RefundItemSelector({
    super.key,
    required this.order,
    required this.refundQuantities,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Items: ${order.orderNumber}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('Total Paid: \$${order.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (ctx, i) {
              final item = order.items[i];
              final currentRefundQty = refundQuantities[item.id] ?? 0.0;
              final unitRefundPrice = item.quantity > 0 ? item.totalAmount / item.quantity : 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Purchased: ${item.quantity.toStringAsFixed(0)} • Unit Price: \$${unitRefundPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text('Refund Qty: ', style: TextStyle(fontSize: 12)),
                        SizedBox(
                          width: 60,
                          height: 36,
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            controller: TextEditingController(text: currentRefundQty.toStringAsFixed(0))
                              ..selection = TextSelection.collapsed(offset: currentRefundQty.toStringAsFixed(0).length),
                            onChanged: (val) {
                              final parsed = double.tryParse(val) ?? 0.0;
                              onQuantityChanged(item.id, parsed, item.quantity);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                        Text(' / ${item.quantity.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
