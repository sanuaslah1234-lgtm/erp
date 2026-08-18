import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onBarcodeScanned;
  final TextEditingController controller;

  const ProductSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onBarcodeScanned,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearchChanged,
        onSubmitted: (val) {
          if (val.trim().isNotEmpty) {
            onBarcodeScanned(val.trim());
          }
        },
        decoration: InputDecoration(
          hintText: 'Search product by name, SKU or scan barcode',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
          suffixIcon: InkWell(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onBarcodeScanned(controller.text.trim());
              }
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.barcode_reader, color: Colors.white, size: 20),
              ),
            ),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

