import 'dart:convert';
import 'package:erp_software/backend/services/employee_service.dart';
import 'package:erp_software/core/errors/api_exception.dart';
import 'package:erp_software/core/utils/response_formatter.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class EmployeeController {
  final EmployeeService employeeService;

  EmployeeController(this.employeeService);

  Future<Response> createEmployee(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      if (bodyStr.isEmpty) {
        return ResponseFormatter.error(message: 'Request body cannot be empty');
      }

      final data = jsonDecode(bodyStr) as Map<String, dynamic>;
      final employee = await employeeService.createEmployee(data);

      return ResponseFormatter.success(
        message: 'Employee created successfully',
        data: employee.toJson(),
        statusCode: 201,
      );
    } on ApiException catch (e) {
      return ResponseFormatter.error(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to create employee', statusCode: 500, error: e);
    }
  }

  Future<Response> getEmployees(Request request) async {
    try {
      final employees = await employeeService.getEmployees();
      return ResponseFormatter.success(
        message: 'Employees fetched successfully',
        data: employees.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to fetch employees', statusCode: 500, error: e);
    }
  }

  Future<Response> getEmployeeById(Request request) async {
    try {
      final idStr = request.params['id'];
      final id = int.tryParse(idStr ?? '');

      if (id == null) {
        return ResponseFormatter.error(message: 'Invalid employee ID');
      }

      final employee = await employeeService.getEmployeeById(id);
      if (employee == null) {
        return ResponseFormatter.error(message: 'Employee not found', statusCode: 404);
      }

      return ResponseFormatter.success(
        message: 'Employee details fetched successfully',
        data: employee.toJson(),
      );
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to fetch employee details', statusCode: 500, error: e);
    }
  }

  Future<Response> updateEmployee(Request request) async {
    try {
      final idStr = request.params['id'];
      final id = int.tryParse(idStr ?? '');

      if (id == null) {
        return ResponseFormatter.error(message: 'Invalid employee ID');
      }

      final bodyStr = await request.readAsString();
      if (bodyStr.isEmpty) {
        return ResponseFormatter.error(message: 'Request body cannot be empty');
      }

      final data = jsonDecode(bodyStr) as Map<String, dynamic>;
      final updated = await employeeService.updateEmployee(id, data);

      if (updated == null) {
        return ResponseFormatter.error(message: 'Employee not found', statusCode: 404);
      }

      return ResponseFormatter.success(
        message: 'Employee updated successfully',
        data: updated.toJson(),
      );
    } on ApiException catch (e) {
      return ResponseFormatter.error(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to update employee', statusCode: 500, error: e);
    }
  }

  Future<Response> toggleEmployeeStatus(Request request) async {
    try {
      final idStr = request.params['id'];
      final id = int.tryParse(idStr ?? '');

      if (id == null) {
        return ResponseFormatter.error(message: 'Invalid employee ID');
      }

      final bodyStr = await request.readAsString();
      bool isActive = true;
      if (bodyStr.isNotEmpty) {
        final data = jsonDecode(bodyStr) as Map<String, dynamic>;
        isActive = data['is_active'] == true;
      }

      await employeeService.toggleEmployeeStatus(id, isActive);

      return ResponseFormatter.success(
        message: 'Employee active status updated to $isActive',
      );
    } on ApiException catch (e) {
      return ResponseFormatter.error(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to toggle employee status', statusCode: 500, error: e);
    }
  }

  Future<Response> deleteEmployee(Request request) async {
    try {
      final idStr = request.params['id'];
      final id = int.tryParse(idStr ?? '');

      if (id == null) {
        return ResponseFormatter.error(message: 'Invalid employee ID');
      }

      final deleted = await employeeService.deleteEmployee(id);
      if (!deleted) {
        return ResponseFormatter.error(message: 'Employee not found', statusCode: 404);
      }

      return ResponseFormatter.success(message: 'Employee deleted successfully');
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to delete employee', statusCode: 500, error: e);
    }
  }
}
