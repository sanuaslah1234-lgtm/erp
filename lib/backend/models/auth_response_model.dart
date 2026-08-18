import 'package:erp_software/backend/models/employee_model.dart';
import 'package:erp_software/backend/models/user_model.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;
  final EmployeeModel? employee;

  const AuthResponseModel({
    required this.token,
    required this.user,
    this.employee,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      if (employee != null) 'employee': employee!.toJson(),
    };
  }
}
