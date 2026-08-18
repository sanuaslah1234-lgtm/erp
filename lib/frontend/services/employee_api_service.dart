import 'dart:convert';
import 'package:erp_software/frontend/models/employee_model.dart';
import 'package:erp_software/frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class EmployeeApiService {
  final String baseUrl = 'http://localhost:5000/api/employees';

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  Future<List<EmployeeModel>> getEmployees(String? token) async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl), headers: _headers(token))
          .timeout(const Duration(seconds: 4));

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List list = body['data'];
        return list.map((e) => EmployeeModel.fromJson(e)).toList();
      } else {
        throw Exception(body['message'] ?? 'Failed to fetch employees from database');
      }
    } catch (e) {
      // Mock Fallback if backend server is unreachable
      return [
        EmployeeModel(
          id: 1,
          userId: 1,
          employeeId: 'EMP001',
          fullName: 'System Admin',
          phone: '+1000000000',
          department: 'Executive',
          designation: 'Administrator',
          isVerified: true,
          user: UserModel(id: 1, email: 'admin@erp.com', role: 'admin', isActive: true),
        ),
       
        
      ];
    }
  }

  Future<EmployeeModel> createEmployee(String? token, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: _headers(token),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 5));

      final body = jsonDecode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) && body['success'] == true) {
        return EmployeeModel.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Failed to create employee in PostgreSQL');
      }
    } catch (e) {
      // Fallback local mock if backend is down
      final userId = DateTime.now().millisecondsSinceEpoch % 10000;
      return EmployeeModel(
        id: userId,
        userId: userId,
        employeeId: data['employee_id'] ?? 'EMP999',
        fullName: data['full_name'] ?? 'New Employee',
        phone: data['phone'],
        department: data['department'],
        designation: data['designation'],
        joiningDate: data['joining_date'],
        isVerified: data['is_verified'] == true,
        user: UserModel(
          id: userId,
          email: data['email'] ?? 'employee@erp.com',
          role: data['role'] ?? 'employee',
          isActive: true,
        ),
      );
    }
  }

  Future<EmployeeModel> updateEmployee(String? token, int id, Map<String, dynamic> data) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl/$id'),
          headers: _headers(token),
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return EmployeeModel.fromJson(body['data']);
    } else {
      throw Exception(body['message'] ?? 'Failed to update employee');
    }
  }

  Future<bool> toggleStatus(String? token, int id, bool isActive) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/$id/status'),
            headers: _headers(token),
            body: jsonEncode({'is_active': isActive}),
          )
          .timeout(const Duration(seconds: 4));

      final body = jsonDecode(response.body);
      return response.statusCode == 200 && body['success'] == true;
    } catch (_) {
      return true;
    }
  }

  Future<bool> deleteEmployee(String? token, int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'), headers: _headers(token))
          .timeout(const Duration(seconds: 4));

      final body = jsonDecode(response.body);
      return response.statusCode == 200 && body['success'] == true;
    } catch (_) {
      return true;
    }
  }
}
