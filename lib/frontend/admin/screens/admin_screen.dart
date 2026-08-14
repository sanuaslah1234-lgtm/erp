import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:erp_software/frontend/admin/branch/providers/branch_provider.dart';
import 'package:erp_software/frontend/admin/branch/screens/branch_list_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BranchProvider(),
      child: const BranchListScreen(),
    );
  }
}

