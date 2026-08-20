import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/landing_page_provider.dart';
import '../widgets/about_section_form.dart';
import '../widgets/footer_section_form.dart';
import '../widgets/hero_section_form.dart';
import '../widgets/navbar_section_form.dart';

/// Drop this into your app's routing / shell in place of the
/// "Settings Landing" tab body. Wrap it (or a parent above it) with
/// ChangeNotifierProvider<LandingPageProvider> — see main.dart.
class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandingPageProvider>().fetchSettings();
    });
  }

  Future<void> _save(LandingPageProvider provider) async {
    final success = await provider.save();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Changes saved successfully' : provider.errorMessage ?? 'Save failed'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LandingPageProvider>();

    if (provider.isLoading && provider.draft.heroTitle.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Landing Page Management',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                if (provider.errorMessage != null) _errorBanner(provider),
                const NavbarSectionForm(),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                const HeroSectionForm(),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                const AboutSectionForm(),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                const FooterSectionForm(),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: (provider.isSaving || !provider.isDirty) ? null : () => _save(provider),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16)),
                    child: provider.isSaving
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorBanner(LandingPageProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(provider.errorMessage!, style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13)),
          ),
        ],
      ),
    );
  }
}