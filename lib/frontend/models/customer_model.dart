class CustomerModel {
  final String? id;
  final bool isActive;
  final String? branchId;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? loyaltyId;
  final double creditLimit;
  final double currentBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerModel({
    this.id,
    this.isActive = true,
    this.branchId,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.loyaltyId,
    this.creditLimit = 0,
    this.currentBalance = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString(),
      isActive: json['is_active'] ?? true,
      branchId: json['branchId']?.toString(),
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      loyaltyId: json['loyaltyId']?.toString(),
      creditLimit:
          double.tryParse(json['creditLimit']?.toString() ?? '0') ?? 0,
      currentBalance:
          double.tryParse(json['currentBalance']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      "isActive":isActive,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'loyaltyId': loyaltyId,
      'creditLimit': creditLimit,
      'currentBalance': currentBalance,
    };
  }
}