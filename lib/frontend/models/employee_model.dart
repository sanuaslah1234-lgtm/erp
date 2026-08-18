import 'package:erp_software/frontend/models/user_model.dart';

class EmployeeModel {
  final int? id;
  final int userId;
  final String employeeId;
  final String fullName;
  final String? phone;
  final String? department;
  final String? designation;
  final String? joiningDate;
  final bool isVerified;
  final String? createdAt;
  final String? updatedAt;

  final UserModel? user;

  EmployeeModel({
    this.id,
    required this.userId,
    required this.employeeId,
    required this.fullName,
    this.phone,
    this.department,
    this.designation,
    this.joiningDate,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      userId: json['user_id'] is int ? json['user_id'] : (int.tryParse(json['user_id']?.toString() ?? '') ?? 0),
      employeeId: json['employee_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      department: json['department']?.toString(),
      designation: json['designation']?.toString(),
      joiningDate: json['joining_date']?.toString(),
      isVerified: json['is_verified'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: json['user'] is Map<String, dynamic> ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'employee_id': employeeId,
      'full_name': fullName,
      'phone': phone,
      'department': department,
      'designation': designation,
      'joining_date': joiningDate,
      'is_verified': isVerified,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (user != null) 'user': user!.toJson(),
    };
  }

  EmployeeModel copyWith({
    int? id,
    int? userId,
    String? employeeId,
    String? fullName,
    String? phone,
    String? department,
    String? designation,
    String? joiningDate,
    bool? isVerified,
    String? createdAt,
    String? updatedAt,
    UserModel? user,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      joiningDate: joiningDate ?? this.joiningDate,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}