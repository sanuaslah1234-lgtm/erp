import 'package:flutter/material.dart';
import 'package:erp_software/frontend/providers/cashier/pos_provider.dart';

class HoldOrderDialog extends StatelessWidget {
  final List<HeldOrder> heldOrders;
  final ValueChanged<HeldOrder> onResumeOrder;

  const HoldOrderDialog({
    super.key,
    required this.heldOrders,
    required this.onResumeOrder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Held POS Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 400,
        child: heldOrders.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No orders currently on hold.', textAlign: TextAlign.center),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: heldOrders.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (ctx, index) {
                  final held = heldOrders[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEEF2FF),
                      child: Icon(Icons.pause_circle_outline, color: Color(0xFF4F46E5)),
                    ),
                    title: Text(held.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('Customer: ${held.customerName ?? "Walk-in"} • ${held.heldAt.hour}:${held.heldAt.minute.toString().padLeft(2, '0')}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        onResumeOrder(held);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Resume', style: TextStyle(fontSize: 12)),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }
}
