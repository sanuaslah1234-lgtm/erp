import 'package:erp_software/core/models/customer_model.dart';
import 'package:erp_software/frontend/services/customer_service.dart';
import 'package:erp_software/frontend/widgets/customers/customer_list.dart';
import 'package:erp_software/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/customers/customer_actions.dart';
import '../../widgets/customers/customer_filters.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final CustomerService customerService = CustomerService();

  List<CustomerModel> customers = [];
  List<CustomerModel> filteredCustomers = [];

  String searchText = '';
  String selectedFilter = 'All';
  String selectedSort = 'DEFAULT';

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final result = await customerService.getCustomers();
      if (!mounted) return;

      setState(() {
        customers = result;
        filteredCustomers = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<CustomerModel> result = List.from(customers);

    // SEARCH
    if (searchText.trim().isNotEmpty) {
      final query = searchText.trim().toLowerCase();

      result = result.where((customer) {
        final name = customer.name.toLowerCase();
        final phone = customer.phone.toLowerCase();
        final email = customer.email?.toLowerCase() ?? '';
        final loyaltyId = customer.loyaltyId?.toLowerCase() ?? '';

        return name.contains(query) ||
            phone.contains(query) ||
            email.contains(query) ||
            loyaltyId.contains(query);
      }).toList();
    }

    // FILTER
    if (selectedFilter == 'Active') {
      result = result.where((customer) {
        return customer.isActive == true;
      }).toList();
    } else if (selectedFilter == 'Inactive') {
      result = result.where((customer) {
        return customer.isActive == false;
      }).toList();
    }

    // SORT
    switch (selectedSort) {
      case 'NAME A-Z':
        result.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;

      case 'NAME Z-A':
        result.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;

      case 'NEWEST':
        result.sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;

          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;

          return bDate.compareTo(aDate);
        });
        break;

      case 'DEFAULT':
      default:
        break;
    }

    if (!mounted) return;

    setState(() {
      filteredCustomers = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadCustomers,
                color: AppColors.primary,
                backgroundColor: AppColors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
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

                      const SizedBox(height: 20),

                      const CustomerActions(),

                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            CustomerFilters(
                              onSearchChanged: (value) {
                                searchText = value;
                                _applyFilters();
                              },

                              onFilterChanged: (value) {
                                selectedFilter = value;
                                _applyFilters();
                              },

                              onSortChanged: (value) {
                                selectedSort = value;
                                _applyFilters();
                              },

                              onReset: () {
                                setState(() {
                                  searchText = '';
                                  selectedFilter = 'All';
                                  selectedSort = 'DEFAULT';
                                  filteredCustomers = List.from(customers);
                                });
                              },
                            ),
                            const Divider(height: 1, color: AppColors.border),

                            CustomerList(
                              customers: filteredCustomers,
                              onDeleted: () async {
                                await loadCustomers();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




