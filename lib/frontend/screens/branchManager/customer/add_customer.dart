import 'package:erp_software/frontend/models/customer_model.dart';
import 'package:erp_software/frontend/services/customer_service.dart';
import 'package:erp_software/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/addCustomer/customer_top_actions.dart';
import '../../../widgets/addCustomer/add_customer.dart';

class AddcustomersScreen extends StatefulWidget {
  const AddcustomersScreen({super.key});

  @override
  State<AddcustomersScreen> createState() => _AddcustomersScreenState();
}

class _AddcustomersScreenState extends State<AddcustomersScreen> {
  final CustomerService customerService = CustomerService();

  bool showAddCustomer = true;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customers',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    CustomerTopActions(
                      onPrint: () {},
                      onExport: () {},
                      onAdd: () {
                        setState(() {
                          showAddCustomer = true;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    if (showAddCustomer)
                      AddCustomerCard(
                        onClose: () {
                          setState(() {
                            showAddCustomer = false;
                          });
                        },

                        onCancel: () {
                          setState(() {
                            showAddCustomer = false;
                          });
                        },

                        onSave: (
                          name,
                          phone,
                          email,
                          address,
                          loyaltyId,
                          currentBalance,
                          creditLimit,
                        ) async {
                          await saveCustomer(
                            name: name,
                            phone: phone,
                            email: email,
                            address: address,
                            loyaltyId: loyaltyId,
                            currentBalance:currentBalance,
                            creditLimit: creditLimit,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
    String? loyaltyId,
    required double currentBalance,
    required double creditLimit,
  }) async {
    if (name.trim().isEmpty) {
      showMessage('Customer name is required',"info");
      return;
    }

    if (phone.trim().isEmpty) {
      showMessage('Phone number is required',"info");
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      final customer = CustomerModel(
        name: name.trim(),
        phone: phone.trim(),
        email: email,
        address: address,
        loyaltyId: loyaltyId,
        creditLimit: creditLimit,
        currentBalance: currentBalance,
      );

      final created =
          await customerService.createCustomer(customer);

      if (!mounted) return;

      setState(() {
        isSaving = false;
        showAddCustomer = false;
      });

      showMessage(
        '${created.name} added successfully',
        "success"
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      showMessage(
        'Failed to add customer: $e',
        "error"
      );
    }
  }

  void showMessage(String message,String type) {
    final SnackBar = type == "success" 
        ? CustomSnackBar.success(message: message) : type == "info" ? CustomSnackBar.info(message: message) : CustomSnackBar.error(message: message);
    showTopSnackBar(
      Overlay.of(context),
      SnackBar
    );
  }
}