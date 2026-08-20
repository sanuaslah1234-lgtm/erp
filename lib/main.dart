import 'package:erp_software/frontend/screens/branchManager/customer/constomer.dart';
import 'package:erp_software/frontend/screens/branchManager/dashboard.dart';
import 'package:erp_software/frontend/screens/branchManager/customer/add_customer.dart';
import 'package:flutter/material.dart';
import 'package:erp_software/theme/app_colors.dart';

void main() {
  runApp(ErpApp());
}

class ErpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erp Application',
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: BranchManagerDashBoard(),
      ),
    );
  }
}

class ApiConfig {
  static const baseUrl = "https://gumming-collapse-subside.ngrok-free.dev";
}
