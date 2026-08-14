import 'package:flutter/material.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  /// Widget displayed in the desktop sidebar
  final Widget Function(BuildContext context) sidebarBuilder;

  /// Widget displayed in the top bar
  final Widget Function(BuildContext context, VoidCallback openDrawer)
      topBarBuilder;

  const AdminLayout({
    super.key,
    required this.child,
    required this.sidebarBuilder,
    required this.topBarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return _buildMobileLayout(context);
        }

        return _buildDesktopLayout(context);
      },
    );
  }

  // ============================================================
  // DESKTOP LAYOUT
  // ============================================================

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ----------------------------------------------------
          // SIDEBAR
          // ----------------------------------------------------

          SizedBox(
            width: 290,
            child: sidebarBuilder(context),
          ),

          // ----------------------------------------------------
          // MAIN AREA
          // ----------------------------------------------------

          Expanded(
            child: Column(
              children: [
                // Top Bar
                SizedBox(
                  height: 72,
                  child: topBarBuilder(
                    context,
                    () {},
                  ),
                ),

                // Current Page
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LAYOUT
  // ============================================================

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 290,
        child: SafeArea(
          child: sidebarBuilder(context),
        ),
      ),
      body: Column(
        children: [
          // ----------------------------------------------------
          // MOBILE TOP BAR
          // ----------------------------------------------------

          SizedBox(
            height: 64,
            child: Builder(
              builder: (context) {
                return topBarBuilder(
                  context,
                  () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),

          // ----------------------------------------------------
          // CURRENT PAGE
          // ----------------------------------------------------

          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}