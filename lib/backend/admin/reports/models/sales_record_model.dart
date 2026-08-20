class SalesRecordModel {
  final int id;
  final String orderNumber;
  final String customerName;
  final double subtotal;
  final double discount;
  final double total;
  final String status;
  final DateTime? createdAt;

  const SalesRecordModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.status,
    this.createdAt,
  });

  factory SalesRecordModel.fromMap(Map<String, dynamic> map) {
    return SalesRecordModel(
      id: map['id'] as int,
      orderNumber: map['order_number']?.toString() ?? '',
      customerName: map['customer_name']?.toString() ?? '',
      subtotal: double.tryParse(map['subtotal'].toString()) ?? 0,
      discount: double.tryParse(map['discount'].toString()) ?? 0,
      total: double.tryParse(map['total'].toString()) ?? 0,
      status: map['status']?.toString() ?? '',
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_name': customerName,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}