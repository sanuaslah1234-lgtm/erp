import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A real, working image picker: tap to choose a file from disk/gallery,
/// it's read into memory, base64-encoded, previewed immediately, and handed
/// back via [onChanged]. Nothing here is a static asset — every image shown
/// is either what's currently saved in the database or what you just picked.
class ImagePickerField extends StatelessWidget {
  final String label;
  final String? base64Value;
  final void Function(String base64) onChanged;
  final double previewHeight;

  const ImagePickerField({
    super.key,
    required this.label,
    required this.base64Value,
    required this.onChanged,
    this.previewHeight = 140,
  });

  Future<void> _pick() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
    if (file == null) return;

    final Uint8List bytes = await file.readAsBytes();
    onChanged(base64Encode(bytes));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pick,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.upload_file_outlined, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 10),
                Text(
                  base64Value != null ? 'Change file' : 'Choose file — No file chosen',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
        if (base64Value != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(base64Value!),
              height: previewHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }
}