class ManagerModel {
  final int id;
  final String employeeId;
  final String fullName;
  final String email;
  final String phone;
  final bool isVerified;
  final int? branchId;
  final String? branchName;
  final String? branchCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ManagerModel({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.isVerified,
    this.branchId,
    this.branchName,
    this.branchCode,
    this.createdAt,
    this.updatedAt,
  });

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      id: map['id'] as int,
      employeeId: map['employee_id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      isVerified: map['is_verified'] as bool? ?? false,
      branchId: map['branch_id'] as int?,
      branchName: map['branch_name']?.toString(),
      branchCode: map['branch_code']?.toString(),
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(map['updated_at'].toString()),
    );
  }

  // Deliberately no password field here — never send it back to the client.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'is_verified': isVerified,
      'branch_id': branchId,
      'branch_name': branchName,
      'branch_code': branchCode,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}