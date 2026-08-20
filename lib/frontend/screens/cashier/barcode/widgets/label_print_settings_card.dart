import 'package:flutter/material.dart';
import 'package:erp_software/frontend/providers/cashier/barcode_provider.dart';
import 'package:provider/provider.dart';

class LabelPrintSettingsCard extends StatelessWidget {
  const LabelPrintSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarcodeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          const Row(
            children: [
              Icon(Icons.tune_rounded, size: 20, color: Color(0xFF0F172A)),
              SizedBox(width: 8),
              Text(
                'Label & Print Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Paper Layout / Preset
          _buildFieldLabel('Paper Layout / Preset'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.paperPreset,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                items: const [
                  DropdownMenuItem(
                    value: '40 Labels Per Sheet (A4 - 52.5mm x 29.7mm)',
                    child: Text('40 Labels Per Sheet (A4 - 52.5mm x 29.7mm)'),
                  ),
                  DropdownMenuItem(
                    value: '24 Labels Per Sheet (A4 - 70mm x 37mm)',
                    child: Text('24 Labels Per Sheet (A4 - 70mm x 37mm)'),
                  ),
                  DropdownMenuItem(
                    value: '50mm x 30mm (Standard Roll)',
                    child: Text('50mm x 30mm (Standard Roll)'),
                  ),
                  DropdownMenuItem(
                    value: '40mm x 25mm (Compact Roll)',
                    child: Text('40mm x 25mm (Compact Roll)'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) provider.setPaperPreset(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Store / Header Name
          _buildFieldLabel('Store / Header Name'),
          SizedBox(
            height: 40,
            child: TextFormField(
              initialValue: provider.storeHeader,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
              ),
              onChanged: (val) => provider.setStoreHeader(val),
            ),
          ),
          const SizedBox(height: 14),

          // 3. Barcode Symbology
          _buildFieldLabel('Barcode Symbology'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.barcodeSymbology,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                items: const [
                  DropdownMenuItem(value: 'CODE128 (Standard)', child: Text('CODE128 (Standard)')),
                  DropdownMenuItem(value: 'EAN-13', child: Text('EAN-13')),
                  DropdownMenuItem(value: 'CODE39', child: Text('CODE39')),
                  DropdownMenuItem(value: 'UPC-A', child: Text('UPC-A')),
                ],
                onChanged: (val) {
                  if (val != null) provider.setBarcodeSymbology(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. Barcode Height Slider
          _buildSliderRow(
            label: 'Barcode Height',
            valueText: '${provider.barcodeHeight.toInt()}px',
            value: provider.barcodeHeight,
            min: 20,
            max: 80,
            onChanged: (val) => provider.setBarcodeHeight(val),
          ),
          const SizedBox(height: 12),

          // 5. Barcode Bar Width Slider
          _buildSliderRow(
            label: 'Barcode Bar Width',
            valueText: '${provider.barWidthMultiplier.toStringAsFixed(1)}x',
            value: provider.barWidthMultiplier,
            min: 0.5,
            max: 3.0,
            onChanged: (val) => provider.setBarWidthMultiplier(val),
          ),
          const SizedBox(height: 12),

          // 6. Barcode Text Size Slider
          _buildSliderRow(
            label: 'Barcode Text Size',
            valueText: '${provider.textSize.toInt()}px',
            value: provider.textSize,
            min: 8,
            max: 20,
            onChanged: (val) => provider.setTextSize(val),
          ),
          const SizedBox(height: 16),

          // 7. Display Fields Checkboxes Grid
          const Text('Display Fields', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildCheckbox('Store Header', provider.showStoreHeader, provider.toggleShowStoreHeader),
                    _buildCheckbox('SKU / Code', provider.showSkuCode, provider.toggleShowSkuCode),
                    _buildCheckbox('Barcode Text', provider.showBarcodeText, provider.toggleShowBarcodeText),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildCheckbox('Product Name', provider.showProductName, provider.toggleShowProductName),
                    _buildCheckbox('Price Tag', provider.showPriceTag, provider.toggleShowPriceTag),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
            Text(valueText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: const Color(0xFF2563EB),
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: const Color(0xFF2563EB),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              activeColor: const Color(0xFF2563EB),
              onChanged: (val) => onChanged(val ?? false),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}
