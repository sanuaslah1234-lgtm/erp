import 'package:erp_software/frontend/screens/employees/employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:erp_software/frontend/screens/cashier/cashier_dashboard_screen.dart';

class ErpSidebar extends StatefulWidget {
  final String activeItem;
  final ValueChanged<String>? onSelect;
  final bool isDrawer;

  const ErpSidebar({
    super.key,
    this.activeItem = 'Employees',
    this.onSelect,
    this.isDrawer = false,
  });

  @override
  State<ErpSidebar> createState() => _ErpSidebarState();
}

class _ErpSidebarState extends State<ErpSidebar> {
  late String _activeItem;

  @override
  void initState() {
    super.initState();
    _activeItem = widget.activeItem;
  }

  @override
  void didUpdateWidget(covariant ErpSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeItem != widget.activeItem) {
      setState(() {
        _activeItem = widget.activeItem;
      });
    }
  }

  void _handleItemTap(String title) {
    setState(() {
      _activeItem = title;
    });
    if (widget.onSelect != null) {
      widget.onSelect!(title);
    }
    if (widget.isDrawer) {
      Navigator.of(context).maybePop();
    }

    if (title == 'Employees' && widget.activeItem != 'Employees') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EmployeesScreen()),
      );
    } else if ((title == 'POS' || title == 'POS Orders' || title == 'Barcode Print' || title == 'Refunds') && widget.activeItem != title) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CashierDashboardScreen(initialTab: title)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFFEBF2FA),
      child: SafeArea(
        child: Column(
          children: [
            if (widget.isDrawer)
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D61F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.badge_outlined, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ERP Mobile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildGroupHeader('BRANCH MANAGER'),
                  _buildMenuItem(Icons.grid_view_outlined, 'Dashboard'),
                  _buildMenuItem(Icons.people_outline, 'Customers'),
                  _buildMenuItem(Icons.inventory_2_outlined, 'Inventory'),
                  _buildMenuItem(Icons.shopping_cart_outlined, 'Sales Orders'),
                  _buildMenuItem(Icons.shopping_bag_outlined, 'Purchases'),
                  _buildMenuItem(Icons.business_outlined, 'Departments'),
                  _buildMenuItem(Icons.group_outlined, 'Designations / Roles'),
                  _buildMenuItem(Icons.badge_outlined, 'Employees'),
                  const SizedBox(height: 20),
                  _buildGroupHeader('CASHIER'),
                  _buildMenuItem(Icons.desktop_windows_outlined, 'POS'),
                  _buildMenuItem(Icons.notes_outlined, 'POS Orders'),
                  _buildMenuItem(Icons.qr_code_scanner_outlined, 'Barcode Print'),
                  _buildMenuItem(Icons.history_outlined, 'Refunds'),
                  const SizedBox(height: 20),
                  _buildGroupHeader('INVENTORY MANAGER'),
                  _buildMenuItem(Icons.all_inbox_outlined, 'Products'),
                  _buildMenuItem(Icons.category_outlined, 'Categories'),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2563EB),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    final isActive = title == _activeItem;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _handleItemTap(title),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF1D61F2) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1D61F2).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: isActive ? Colors.white : const Color(0xFF475569),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? Colors.white : const Color(0xFF334155),
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
}

