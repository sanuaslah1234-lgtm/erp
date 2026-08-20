import 'package:erp_software/frontend/screens/branchManager/inventory/add_inventory_screen.dart';
import 'package:flutter/material.dart';

import 'package:erp_software/frontend/models/inventory_model.dart';
import 'package:erp_software/frontend/services/inventory_service.dart';
import 'package:erp_software/frontend/widgets/inventory/inventory_actions.dart';
import 'package:erp_software/frontend/widgets/inventory/inventory_filters.dart';
import 'package:erp_software/frontend/widgets/inventory/inventory_stats.dart';
import 'package:erp_software/frontend/widgets/inventory/inventory_table.dart';
import 'package:erp_software/theme/app_colors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryService _inventoryService = InventoryService();

  // ==========================================================
  // STATE
  // ==========================================================

  List<InventoryItem> inventory = [];

  bool isLoading = true;
  String? errorMessage;

  String search = '';

  // Keep ID internally.
  String? selectedWarehouseId;

  String selectedStatus = 'All Statuses';
  String selectedSort = 'Latest';

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  // ==========================================================
  // LOAD INVENTORY
  // ==========================================================

  Future<void> _loadInventory() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _inventoryService.getInventory(
        search: search.trim().isEmpty
            ? null
            : search.trim(),

        warehouseId: selectedWarehouseId,

        status: selectedStatus == 'All Statuses'
            ? null
            : selectedStatus,
      );

      if (!mounted) return;

      setState(() {
        inventory = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ==========================================================
  // FILTERED / SORTED INVENTORY
  // ==========================================================

  List<InventoryItem> get filteredInventory {
    final result = List<InventoryItem>.from(inventory);

    switch (selectedSort) {
      case 'A-Z':
        result.sort(
          (a, b) => a.product
              .toLowerCase()
              .compareTo(
                b.product.toLowerCase(),
              ),
        );
        break;

      case 'Z-A':
        result.sort(
          (a, b) => b.product
              .toLowerCase()
              .compareTo(
                a.product.toLowerCase(),
              ),
        );
        break;

      case 'Quantity Low':
        result.sort(
          (a, b) => a.quantity.compareTo(
            b.quantity,
          ),
        );
        break;

      case 'Quantity High':
        result.sort(
          (a, b) => b.quantity.compareTo(
            a.quantity,
          ),
        );
        break;

      case 'Latest':
      default:
        result.sort(
          (a, b) {
            final aDate = a.createdAt;
            final bDate = b.createdAt;

            if (aDate == null && bDate == null) {
              return 0;
            }

            if (aDate == null) {
              return 1;
            }

            if (bDate == null) {
              return -1;
            }

            return bDate.compareTo(aDate);
          },
        );
        break;
    }

    return result;
  }

  // ==========================================================
  // DYNAMIC WAREHOUSES
  // ==========================================================

  List<Map<String, String>> get warehouses {
    final Map<String, String> uniqueWarehouses = {};

    for (final item in inventory) {
      if (item.warehouseId.isNotEmpty &&
          item.warehouse.isNotEmpty) {
        uniqueWarehouses[item.warehouseId] =
            item.warehouse;
      }
    }

    return uniqueWarehouses.entries
        .map(
          (entry) => {
            'id': entry.key,
            'name': entry.value,
          },
        )
        .toList();
  }

  // ==========================================================
  // STATS
  // ==========================================================

  int get totalRecords => inventory.length;

  int get healthyStock {
    return inventory
        .where(
          (item) => item.status == 'In Stock',
        )
        .length;
  }

  int get lowStock {
    return inventory
        .where(
          (item) => item.status == 'Low Stock',
        )
        .length;
  }

  int get outOfStock {
    return inventory
        .where(
          (item) => item.status == 'Out of Stock',
        )
        .length;
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> _deleteItem(
    InventoryItem item,
  ) async {
    if (item.id == null || item.id!.isEmpty) {
      _showMessage(
        'Inventory ID is missing',
        isError: true,
      );
      return;
    }

    try {
      await _inventoryService.deleteInventory(
        item.id!,
      );

      if (!mounted) return;

      setState(() {
        inventory.removeWhere(
          (x) => x.id == item.id,
        );
      });

      _showMessage(
        'Inventory item deleted',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Failed to delete inventory',
        isError: true,
      );
    }
  }

  // ==========================================================
  // VIEW
  // ==========================================================

  void _viewItem(
    InventoryItem item,
  ) {
    _showItemSheet(
      context,
      item,
      title: 'Inventory Details',
    );
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  void _editItem(
    InventoryItem item,
  ) {
    _showItemSheet(
      context,
      item,
      title: 'Edit Inventory',
    );
  }

  // ==========================================================
  // DETAILS SHEET
  // ==========================================================

  void _showItemSheet(
    BuildContext context,
    InventoryItem item, {
    required String title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w700,
                          color:
                              AppColors.textPrimary,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _DetailRow(
                  label: 'Product',
                  value: item.product,
                ),

                _DetailRow(
                  label: 'SKU',
                  value: item.sku,
                ),

                _DetailRow(
                  label: 'Warehouse',
                  value: item.warehouse,
                ),

                _DetailRow(
                  label: 'Quantity',
                  value: '${item.quantity}',
                ),

                _DetailRow(
                  label: 'Minimum Stock',
                  value: '${item.minStock}',
                ),

                _DetailRow(
                  label: 'Maximum Stock',
                  value: '${item.maxStock}',
                ),

                _DetailRow(
                  label: 'Reorder Level',
                  value: '${item.reorderLevel}',
                ),

                _DetailRow(
                  label: 'Status',
                  value: item.status,
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addInventory() {
  Navigator.push(context, MaterialPageRoute(builder: (_)=> AddInventoryScreen()));
  }

  void _printInventory() {
    _showMessage(
      'Print inventory',
    );
  }

  void _exportInventory() {
    _showMessage(
      'Export inventory',
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
              SnackBarBehavior.floating,
          backgroundColor:
              isError ? Colors.red : null,
        ),
      );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.pageBackground,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final isMobile =
                constraints.maxWidth < 600;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 24,
                isMobile ? 18 : 24,
                isMobile ? 14 : 24,
                30,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1500,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // TITLE
                      // ==================================================

                      _PageTitle(
                        isMobile: isMobile,
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // ACTIONS
                      // ==================================================

                      InventoryActions(
                        isMobile: isMobile,
                        onAdd: _addInventory,
                        onPrint: _printInventory,
                        onExport:
                            _exportInventory,
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      // ==================================================
                      // STATS
                      // ==================================================

                      InventoryStats(
                        totalRecords:
                            totalRecords,
                        healthyStock:
                            healthyStock,
                        lowStock:
                            lowStock,
                        outOfStock:
                            outOfStock,
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      // ==================================================
                      // FILTERS
                      // ==================================================

                      InventoryFilters(
  search: search,

  selectedWarehouseId:
      selectedWarehouseId,

  selectedStatus:
      selectedStatus,

  selectedSort:
      selectedSort,

  warehouses:
      warehouses,

  onSearchChanged: (value) {
    setState(() {
      search = value;
    });

    _loadInventory();
  },

  onWarehouseChanged: (value) {
    setState(() {
      selectedWarehouseId = value;
    });

    _loadInventory();
  },

  onStatusChanged: (value) {
    setState(() {
      selectedStatus =
          value ?? 'All Statuses';
    });

    _loadInventory();
  },

  onSortChanged: (value) {
    setState(() {
      selectedSort =
          value ?? 'Latest';
    });
  },

  onRefresh: _loadInventory,
),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // CONTENT
                      // ==================================================

                      _buildInventoryContent(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // INVENTORY CONTENT
  // ==========================================================

  Widget _buildInventoryContent() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(50),
        child: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return _ErrorState(
        message: errorMessage!,
        onRetry: _loadInventory,
      );
    }

    if (filteredInventory.isEmpty) {
      return const _EmptyState();
    }

    return InventoryTable(
      items: filteredInventory,
      onView: _viewItem,
      onEdit: _editItem,
      onDelete: _deleteItem,
    );
  }
}

// ==========================================================
// PAGE TITLE
// ==========================================================

class _PageTitle extends StatelessWidget {
  final bool isMobile;

  const _PageTitle({
    required this.isMobile,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Inventory Management',
          style: TextStyle(
            fontSize:
                isMobile ? 24 : 30,
            fontWeight:
                FontWeight.w800,
            letterSpacing: -.5,
            color:
                AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Monitor stock levels and manage your inventory.',
          style: TextStyle(
            fontSize: 12,
            color:
                AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// DETAIL ROW
// ==========================================================

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color:
                    AppColors.textMuted,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
                color:
                    AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// ERROR STATE
// ==========================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(30),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 42,
            color: Colors.red,
          ),

          const SizedBox(height: 12),

          const Text(
            'Failed to load inventory',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            message,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// EMPTY STATE
// ==========================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color:
                AppColors.textMuted,
          ),

          const SizedBox(height: 12),

          const Text(
            'No inventory found',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Try changing your filters or search.',
            style: TextStyle(
              fontSize: 12,
              color:
                  AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}