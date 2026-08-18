import 'package:erp_software/frontend/admin/reports/screens/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frontend/admin/audit_log/providers/audit_log_provider.dart';
import 'frontend/admin/audit_log/screens/audit_log_screen.dart';
// import 'frontend/admin/audit_log/screens/employee_timeline_screen.dart';
import 'frontend/admin/branch/providers/branch_provider.dart';
import 'frontend/admin/branch/screens/branch_screen.dart';
import 'frontend/admin/landing_page/providers/landing_page_provider.dart';
import 'frontend/admin/landing_page/screens/landing_page_screen.dart';
import 'frontend/admin/manager/providers/manager_provider.dart';
import 'frontend/admin/manager/screens/manager_screen.dart';
import 'frontend/admin/reports/providers/reports_provider.dart';
import 'frontend/admin/reports/providers/purchase_reports_provider.dart';
import 'frontend/admin/reports/providers/inventory_reports_provider.dart';
import 'frontend/admin/settings/providers/settings_provider.dart';
import 'frontend/admin/settings/screens/settings_screen.dart';

/// ⚠️ This file is a STANDALONE test harness for the Branch module only.
/// Your real app already has main.dart + the shared sidebar/topbar shell
/// your teammate built. Don't overwrite your real main.dart with this —
/// instead:
///   1. Add ChangeNotifierProvider<BranchProvider> near the root of your
///      existing provider tree (see below).
///   2. Put `const BranchScreen()` as the body when the "Branch" sidebar
///      item is selected.


void main() {
  runApp(const ErpApp());
}

class ErpApp extends StatelessWidget {
  const ErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        title: 'ERP Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF2563EB),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        ),
        home: const Scaffold(
          body: SafeArea(child:LandingPageScreen()),
        ),
      ),
    );
  }
}