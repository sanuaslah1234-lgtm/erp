import 'package:flutter/material.dart';

/// A plain text field bound to provider state. Manages its own
/// TextEditingController so typing doesn't get interrupted by rebuilds —
/// only re-syncs the controller when [value] changes from OUTSIDE typing
/// (e.g. after Reset Defaults or initial load), not on every keystroke.
class SectionTextField extends StatefulWidget {
  final String label;
  final String value;
  final void Function(String) onChanged;
  final int maxLines;
  final TextInputType? keyboardType;

  const SectionTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  State<SectionTextField> createState() => _SectionTextFieldState();
}

class _SectionTextFieldState extends State<SectionTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SectionTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only resync if the value changed for a reason OTHER than our own
    // typing (typing already keeps widget.value == _controller.text).
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        TextField(
          controller: _controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}