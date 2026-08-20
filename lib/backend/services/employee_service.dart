import 'package:erp_software/backend/models/employee_model.dart';
import 'package:erp_software/backend/repositories/auth_repository.dart';
import 'package:erp_software/backend/repositories/employee_repository.dart';
import 'package:erp_software/backend/services/password_service.dart';
import 'package:erp_software/core/errors/api_exception.dart';

class EmployeeService {
  final EmployeeRepository employeeRepository;
  final AuthRepository authRepository;

  EmployeeService({
    required this.employeeRepository,
    required this.authRepository,
  });

  Future<EmployeeModel> createEmployee(Map<String, dynamic> data) async {
    final email = data['email']?.toString().trim();
    final rawPassword = data['password']?.toString();
    final employeeId = data['employee_id']?.toString().trim();
    final fullName = data['full_name']?.toString().trim();

    if (email == null || email.isEmpty || !email.contains('@')) {
      throw ApiException('Valid email is required');
    }
    if (rawPassword == null || rawPassword.length < 4) {
      throw ApiException('Password must be at least 4 characters long');
    }
    if (employeeId == null || employeeId.isEmpty) {
      throw ApiException('Employee ID is required');
    }
    if (fullName == null || fullName.isEmpty) {
      throw ApiException('Full Name is required');
    }

    final existingUser = await authRepository.findUserByEmail(email);
    if (existingUser != null) {
      throw ApiException('User with this email already exists');
    }

    final hashedPassword = PasswordService.hashPassword(rawPassword);

    return await employeeRepository.createEmployeeTransaction(
      email: email,
      hashedPassword: hashedPassword,
      role: data['role']?.toString() ?? 'employee',
      employeeId: employeeId,
      fullName: fullName,
      phone: data['phone']?.toString(),
      department: data['department']?.toString(),
      designation: data['designation']?.toString(),
      joiningDate: data['joining_date']?.toString(),
      isVerified: data['is_verified'] == true,
    );
  }

  Future<List<EmployeeModel>> getEmployees() async {
    return await employeeRepository.getAllEmployees();
  }

  Future<EmployeeModel?> getEmployeeById(int id) async {
    return await employeeRepository.getEmployeeById(id);
  }

  Future<EmployeeModel?> updateEmployee(int id, Map<String, dynamic> data) async {
    return await employeeRepository.updateEmployee(id, data);
  }

  Future<bool> toggleEmployeeStatus(int id, bool isActive) async {
    final emp = await employeeRepository.getEmployeeById(id);
    if (emp == null) throw ApiException('Employee not found', statusCode: 404);

    await authRepository.toggleUserActiveStatus(emp.userId, isActive);
    return true;
  }

  Future<bool> deleteEmployee(int id) async {
    return await employeeRepository.deleteEmployee(id);
  }
}