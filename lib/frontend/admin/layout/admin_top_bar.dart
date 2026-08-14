import 'package:flutter/material.dart';

class AdminTopBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;

  const AdminTopBar({
    super.key,
    this.onMenuPressed,
  });

  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Color(0xFF334155);
  static const Color mutedColor = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          // ==================================================
          // MENU BUTTON
          // ==================================================

          _buildIconButton(
            icon: Icons.menu_rounded,
            onPressed: onMenuPressed,
            tooltip: 'Menu',
          ),

          const SizedBox(width: 18),

          // ==================================================
          // SEARCH
          // ==================================================

          Expanded(
            child: _buildSearchBox(context),
          ),

          const SizedBox(width: 16),

          // ==================================================
          // LANGUAGE
          // ==================================================

          _buildIconButton(
            icon: Icons.language_rounded,
            onPressed: () {
              // Language functionality will be added later.
            },
            tooltip: 'Language',
          ),

          const SizedBox(width: 8),

          // ==================================================
          // DARK MODE
          // ==================================================

          _buildIconButton(
            icon: Icons.dark_mode_outlined,
            onPressed: () {
              // Theme switching will be added later.
            },
            tooltip: 'Theme',
          ),

          const SizedBox(width: 8),

          // ==================================================
          // NOTIFICATIONS
          // ==================================================

          _buildNotificationButton(),

          const SizedBox(width: 8),

          // ==================================================
          // SETTINGS
          // ==================================================

          _buildIconButton(
            icon: Icons.settings_outlined,
            onPressed: () {
              // Settings navigation will be added later.
            },
            tooltip: 'Settings',
          ),

          const SizedBox(width: 16),

          // ==================================================
          // PROFILE
          // ==================================================

          _buildProfile(context),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH BOX
  // ============================================================

  Widget _buildSearchBox(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 520,
      ),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search ERP...',
            hintStyle: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 21,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ICON BUTTON
  // ============================================================

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Icon(
              icon,
              size: 21,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION BUTTON
  // ============================================================

  Widget _buildNotificationButton() {
    return Tooltip(
      message: 'Notifications',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Notification functionality will be added later.
          },
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 21,
                    color: textColor,
                  ),
                ),

                // Notification count
                Positioned(
                  right: -3,
                  top: -4,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
  // PROFILE
  // ============================================================

  Widget _buildProfile(BuildContext context) {
    return InkWell(
      onTap: () {
        _showProfileMenu(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
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

          const SizedBox(width: 10),

          // Name and role
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Administrator',
                style: TextStyle(
                  fontSize: 11,
                  color: mutedColor,
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),

          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: mutedColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE MENU
  // ============================================================

  void _showProfileMenu(BuildContext context) {
    showMenu<void>(
      context: context,
      position: const RelativeRect.fromLTRB(
        1000,
        70,
        20,
        0,
      ),
      items: const [
        PopupMenuItem<void>(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 20,
              ),
              SizedBox(width: 10),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem<void>(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 20,
              ),
              SizedBox(width: 10),
              Text('Settings'),
            ],
          ),
        ),
        PopupMenuItem<void>(
          value: 3,
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 20,
                color: Color(0xFFDC2626),
              ),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
