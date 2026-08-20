import 'package:erp_software/backend/models/user_model.dart';

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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Joined user entity
  final UserModel? user;

  const EmployeeModel({
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
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (user != null) 'user': user!.toJson(),
    };
  }
}