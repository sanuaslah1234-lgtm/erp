import 'package:erp_software/frontend/models/employee_model.dart';
import 'package:erp_software/frontend/models/user_model.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;
  final EmployeeModel? employee;

  AuthResponseModel({
    required this.token,
    required this.user,
    this.employee,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }
}
