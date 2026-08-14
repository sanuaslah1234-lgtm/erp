import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedPage;
  final ValueChanged<String>? onPageSelected;

  const AdminSidebar({
    super.key,
    this.selectedPage = 'Branch',
    this.onPageSelected,
  });

  static const Color primaryColor = Color(0xFF2563EB);
  static const Color sidebarColor = Color(0xFFE7F0FB);
  static const Color textColor = Color(0xFF334155);
  static const Color mutedColor = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: sidebarColor,
      child: Column(
        children: [
          _buildLogo(),

          const SizedBox(height: 22),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 12,
                    ),
                    child: Text(
                      'ADMIN',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.grid_view_rounded,
                    title: 'Dashboard',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Branch',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.people_outline_rounded,
                    title: 'Manager',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.access_time_rounded,
                    title: 'Audit Log',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                  ),

                  const SizedBox(height: 18),

                  _buildLogoutItem(context),
                ],
              ),
            ),
          ),

          _buildUserAvatar(),
        ],
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: const Text(
        'ERP SYSTEM',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E3A8A),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final bool isSelected = selectedPage == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () {
            onPageSelected?.call(title);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: isSelected ? Colors.white : textColor,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () {
            // Logout functionality will be connected later.
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 21,
                  color: Color(0xFFDC2626),
                ),
                SizedBox(width: 15),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // USER AVATAR
  // ============================================================

  Widget _buildUserAvatar() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF1E293B),
        ),
        child: const Center(
          child: Text(
            'A',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

