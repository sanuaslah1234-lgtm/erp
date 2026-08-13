class EmployeeModel {
  final int? id;
  final String employeeId;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final bool isVerified;
  final String? createdAt;
  final String? updatedAt;

  EmployeeModel({
    this.id,
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.isVerified = true,
    this.createdAt,
    this.updatedAt,
  });

  // API JSON → EmployeeModel
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
      isVerified: json['is_verified'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  // EmployeeModel → API JSON
  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'is_verified': isVerified,
    };
  }

  // Useful when editing an existing employee
  EmployeeModel copyWith({
    int? id,
    String? employeeId,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    bool? isVerified,
    String? createdAt,
    String? updatedAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}