import 'package:flutter/material.dart';

class PaymentDialogResult {
  final String paymentMethod;
  final double amountReceived;
  final String? referenceNumber;

  PaymentDialogResult({
    required this.paymentMethod,
    required this.amountReceived,
    this.referenceNumber,
  });
}

class PaymentDialog extends StatefulWidget {
  final double grandTotal;

  const PaymentDialog({super.key, required this.grandTotal});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String _selectedMethod = 'Cash';
  late TextEditingController _amountReceivedController;
  final TextEditingController _refController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountReceivedController = TextEditingController(text: widget.grandTotal.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _amountReceivedController.dispose();
    _refController.dispose();
    super.dispose();
  }

  double get _amountReceived => double.tryParse(_amountReceivedController.text) ?? 0.0;
  double get _changeAmount => (_amountReceived - widget.grandTotal).clamp(0.0, double.infinity);
  bool get _isValid => _selectedMethod != 'Cash' || _amountReceived >= widget.grandTotal;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.point_of_sale, color: Color(0xFF2563EB)),
                      SizedBox(width: 8),
                      Text('POS Checkout Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
      
              // Total Due Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('TOTAL AMOUNT DUE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                    const SizedBox(height: 4),
                    Text(
                      '\$${widget.grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
      
              // Payment Method Selector
              const Text('Payment Method', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 8),
              Row(
                children: ['Cash', 'Card', 'UPI', 'Mixed'].map((method) {
                  final isSel = _selectedMethod == method;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ChoiceChip(
                        label: Text(method, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                        selected: isSel,
                        selectedColor: const Color(0xFF2563EB),
                        labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87),
                        onSelected: (_) {
                          setState(() {
                            _selectedMethod = method;
                            if (method != 'Cash') {
                              _amountReceivedController.text = widget.grandTotal.toStringAsFixed(2);
                            }
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
      
              if (_selectedMethod == 'Cash') ...[
                const Text('Amount Received from Customer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountReceivedController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
      
                // Preset Cash Quick Buttons
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [widget.grandTotal, 10.0, 20.0, 50.0, 100.0].map((preset) {
                    return ActionChip(
                      label: Text(preset == widget.grandTotal ? 'Exact (\$$preset)' : '\$$preset'),
                      onPressed: () {
                        setState(() {
                          _amountReceivedController.text = preset.toStringAsFixed(2);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
      
                // Change calculation box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _changeAmount > 0 ? Colors.green.shade50 : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _changeAmount > 0 ? Colors.green.shade200 : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Change to Return:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_changeAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _changeAmount > 0 ? Colors.green.shade800 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
      
              if (_selectedMethod == 'Card' || _selectedMethod == 'UPI' || _selectedMethod == 'Mixed') ...[
                const Text('Reference / Transaction ID (Optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 8),
                TextField(
                  controller: _refController,
                  decoration: InputDecoration(
                    hintText: _selectedMethod == 'UPI' ? 'UPI Ref / UTR No' : 'Card Auth / Ref Code',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
              const SizedBox(height: 24),
      
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          Navigator.pop(
                            context,
                            PaymentDialogResult(
                              paymentMethod: _selectedMethod,
                              amountReceived: _amountReceived,
                              referenceNumber: _refController.text.trim().isNotEmpty ? _refController.text.trim() : null,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Complete & Process Order', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
