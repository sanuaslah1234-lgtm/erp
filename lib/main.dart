import 'package:erp_software/frontend/admin/landing_page/screens/landing_page_screen.dart';
import 'package:erp_software/frontend/admin/settings/screens/settings_screen.dart';
import 'package:erp_software/frontend/screens/admin/branch_screen.dart';
import 'package:erp_software/frontend/screens/admin/manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frontend/admin/audit_log/providers/audit_log_provider.dart';
import 'frontend/admin/branch/providers/branch_provider.dart';
import 'frontend/admin/landing_page/providers/landing_page_provider.dart';
import 'frontend/admin/manager/providers/manager_provider.dart';
import 'frontend/admin/reports/providers/inventory_reports_provider.dart';
import 'frontend/admin/reports/providers/purchase_reports_provider.dart';
import 'frontend/admin/reports/providers/reports_provider.dart';
import 'frontend/admin/settings/providers/settings_provider.dart';
import 'frontend/providers/auth_provider.dart';
import 'frontend/providers/cashier/barcode_provider.dart';
import 'frontend/providers/cashier/cashier_settings_provider.dart';
import 'frontend/providers/cashier/order_provider.dart';
import 'frontend/providers/cashier/pos_provider.dart';
import 'frontend/providers/cashier/refund_provider.dart';
import 'frontend/providers/employee_provider.dart';
import 'frontend/screens/dashboard/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ErpApp());
}

class ErpApp extends StatelessWidget {
  const ErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => PosProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => BarcodeProvider()),
        ChangeNotifierProvider(create: (_) => RefundProvider()),
        ChangeNotifierProvider(create: (_) => CashierSettingsProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseReportsProvider()),
        ChangeNotifierProvider(create: (_) => InventoryReportsProvider()),
        ChangeNotifierProvider(create: (_) => ManagerProvider()),
        ChangeNotifierProvider(create: (_) => AuditLogProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => LandingPageProvider()),
      ],
      child: MaterialApp(
        title: 'Retail ERP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SafeArea(child: SettingsScreen()),
        )
      ),
    );
  }
}