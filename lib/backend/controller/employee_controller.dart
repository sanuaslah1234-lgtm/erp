import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:erp_software/backend/services/employee_service.dart';

class EmployeeController {
  final EmployeeService employeeService;

  EmployeeController(this.employeeService);

  // ============================================================
  // POST /employees
  // CREATE EMPLOYEE
  // ============================================================

  Future<Response> createEmployee(Request request) async {
    try {
      final body = await request.readAsString();

      if (body.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Request body cannot be empty',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final data = jsonDecode(body);

      if (data is! Map<String, dynamic>) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Invalid request body',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final requiredFields = [
        'employee_id',
        'full_name',
        'email',
        'phone',
        'role',
        'password',
      ];

      for (final field in requiredFields) {
        final value = data[field];

        if (value == null || value.toString().trim().isEmpty) {
          return Response.badRequest(
            body: jsonEncode({
              'success': false,
              'message': '$field is required',
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          );
        }
      }

      final employee = await employeeService.createEmployee(data);

      return Response(
        201,
        body: jsonEncode({
          'success': true,
          'message': 'Employee created successfully',
          'data': employee,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'message': 'Invalid JSON format',
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'message': 'Failed to create employee',
          'error': e.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }
  }

  // ============================================================
  // GET /employees
  // GET ALL EMPLOYEES
  // ============================================================

  Future<Response> getEmployees(Request request) async {
    try {
      final employees = await employeeService.getEmployees();

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Employees fetched successfully',
          'data': employees,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'message': 'Failed to fetch employees',
          'error': e.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }
  }

  // ============================================================
  // GET /employees/<id>
  // GET EMPLOYEE BY ID
  // ============================================================

  Future<Response> getEmployeeById(Request request) async {
    try {
      final id = int.tryParse(request.params['id'] ?? '');

      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Invalid employee ID',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final employee = await employeeService.getEmployeeById(id);

      if (employee == null) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'Employee not found',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Employee fetched successfully',
          'data': employee,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'message': 'Failed to fetch employee',
          'error': e.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }
  }

  // ============================================================
  // PUT /employees/<id>
  // UPDATE EMPLOYEE
  // ============================================================

  Future<Response> updateEmployee(Request request) async {
    try {
      final id = int.tryParse(request.params['id'] ?? '');

      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Invalid employee ID',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final body = await request.readAsString();

      if (body.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Request body cannot be empty',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final data = jsonDecode(body);

      if (data is! Map<String, dynamic>) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Invalid request body',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final requiredFields = [
        'employee_id',
        'full_name',
        'email',
        'phone',
        'role',
      ];

      for (final field in requiredFields) {
        final value = data[field];

        if (value == null || value.toString().trim().isEmpty) {
          return Response.badRequest(
            body: jsonEncode({
              'success': false,
              'message': '$field is required',
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          );
        }
      }

      final employee = await employeeService.updateEmployee(
        id,
        data,
      );

      if (employee == null) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'Employee not found',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Employee updated successfully',
          'data': employee,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'message': 'Invalid JSON format',
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'message': 'Failed to update employee',
          'error': e.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }
  }

  // ============================================================
  // DELETE /employees/<id>
  // DELETE EMPLOYEE
  // ============================================================

  Future<Response> deleteEmployee(Request request) async {
    try {
      final id = int.tryParse(request.params['id'] ?? '');

      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'message': 'Invalid employee ID',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final deleted = await employeeService.deleteEmployee(id);

      if (!deleted) {
        return Response.notFound(
          jsonEncode({
            'success': false,
            'message': 'Employee not found',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Employee deleted successfully',
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'message': 'Failed to delete employee',
          'error': e.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }
  }
}