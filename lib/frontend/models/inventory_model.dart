class InventoryItem {
  final String? id;

  final String productId;
  final String product;
  final String sku;

  final String warehouseId;
  final String warehouse;

  final int quantity;
  final int minStock;
  final int maxStock;
  final int reorderLevel;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  InventoryItem({
    this.id,
    required this.productId,
    required this.product,
    required this.sku,
    required this.warehouseId,
    required this.warehouse,
    required this.quantity,
    required this.minStock,
    required this.maxStock,
    required this.reorderLevel,
    this.createdAt,
    this.updatedAt,
  });

  // ==========================================================
  // STATUS
  // ==========================================================

  String get status {
    if (quantity <= 0) {
      return 'Out of Stock';
    }

    if (quantity <= minStock) {
      return 'Low Stock';
    }

    return 'In Stock';
  }

  // ==========================================================
  // FROM JSON
  // ==========================================================

  factory InventoryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final productData =
        json['product'] as Map<String, dynamic>?;

    final warehouseData =
        json['warehouse'] as Map<String, dynamic>?;

    return InventoryItem(
      id: json['id']?.toString(),

      productId:
          json['productId']?.toString() ??
          json['product_id']?.toString() ??
          '',

      product:
          productData?['name']?.toString() ??
          json['productName']?.toString() ??
          json['product']?.toString() ??
          '',

      sku:
          productData?['sku']?.toString() ??
          json['sku']?.toString() ??
          '',

      warehouseId:
          json['warehouseId']?.toString() ??
          json['warehouse_id']?.toString() ??
          '',

      warehouse:
          warehouseData?['name']?.toString() ??
          json['warehouseName']?.toString() ??
          json['warehouse']?.toString() ??
          '',

      quantity:
          _toInt(json['quantity']),

      minStock:
          _toInt(
            json['minimumStock'] ??
            json['minimum_stock'],
          ),

      maxStock:
          _toInt(
            json['maximumStock'] ??
            json['maximum_stock'],
          ),

      reorderLevel:
          _toInt(
            json['reorderLevel'] ??
            json['reorder_level'],
          ),

      createdAt: _toDate(json['createdAt']),

      updatedAt: _toDate(json['updatedAt']),
    );
  }

  // ==========================================================
  // TO JSON
  // ==========================================================

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'warehouseId': warehouseId,
      'quantity': quantity,
      'minimumStock': minStock,
      'maximumStock': maxStock,
      'reorderLevel': reorderLevel,
    };
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(
      value.toString(),
    );
  }
}