import 'package:erp_software/backend/database/postgres_service.dart';

class EmployeeService {
  final PostgresService postgresService;

  EmployeeService(this.postgresService);

  // CREATE EMPLOYEE
  Future<Map<String, dynamic>> createEmployee(
    Map<String, dynamic> data,
  ) async {
    return await postgresService.createEmployee(data);
  }

  // GET ALL EMPLOYEES
  Future<List<Map<String, dynamic>>> getEmployees() async {
    return await postgresService.getEmployees();
  }

  // GET EMPLOYEE BY ID
  Future<Map<String, dynamic>?> getEmployeeById(int id) async {
    return await postgresService.getEmployeeById(id);
  }

  // UPDATE EMPLOYEE
  Future<Map<String, dynamic>?> updateEmployee(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await postgresService.updateEmployee(id, data);
  }

  // DELETE EMPLOYEE
  Future<bool> deleteEmployee(int id) async {
    return await postgresService.deleteEmployee(id);
  }
}