class EmployeeModel {
  final int? id;
  final String employeeId;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? password;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmployeeModel({
    this.id,
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.password,
    this.isVerified = true,
    this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // FROM JSON
  // ============================================================

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      employeeId: json['employee_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      password: json['password']?.toString(),
      isVerified: json['is_verified'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'password': password,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  EmployeeModel copyWith({
    int? id,
    String? employeeId,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? password,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}