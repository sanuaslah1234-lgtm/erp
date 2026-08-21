import 'package:erp_software/backend/database/postgres_service.dart';
import 'package:postgres/postgres.dart';

import 'package:erp_software/core/models/employee_model.dart';

class EmployeeService {
  final PostgresService postgresService;

  EmployeeService(this.postgresService);

  // =========================================================
  // GET ALL EMPLOYEES
  // =========================================================

  Future<List<EmployeeModel>> getEmployees() async {
    final result = await postgresService.connection.execute(
      Sql.named('''
        SELECT
          id,
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          is_verified,
          first_login,
          role,
          branch_id
        FROM employees
        ORDER BY full_name ASC
      '''),
    );

    return result
        .map(
          (row) => EmployeeModel.fromMap(
            row.toColumnMap(),
          ),
        )
        .toList();
  }

  // =========================================================
  // GET ONE EMPLOYEE
  // =========================================================

  Future<EmployeeModel?> getEmployeeById(
    String id,
  ) async {
    final result = await postgresService.connection.execute(
      Sql.named('''
        SELECT
          id,
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          is_verified,
          first_login,
          role,
          branch_id
        FROM employees
        WHERE id = @id
        LIMIT 1
      '''),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    return EmployeeModel.fromMap(
      result.first.toColumnMap(),
    );
  }

  // =========================================================
  // CREATE EMPLOYEE
  // =========================================================

  Future<EmployeeModel> createEmployee({
    required String fullName,
    required String email,
    required String employeeId,
    required String phone,
    required String passwordHash,
    String? role,
    String? roleId,
    String? type,
    String? branchId,
  }) async {
    final result = await postgresService.connection.execute(
      Sql.named('''
        INSERT INTO employees (
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          is_verified,
          first_login,
          role,
          branch_id
        )
        VALUES (
          @fullName,
          @email,
          @employeeId,
          @phone,
          @passwordHash,
          false,
          true,
          @role,
          @branchId
        )
        RETURNING
          id,
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          is_verified,
          first_login,
          role,
          branch_id
      '''),
      parameters: {
        'fullName': fullName,
        'email': email,
        'employeeId': employeeId,
        'phone': phone,
        'passwordHash': passwordHash,
        'role': role,
        'branchId': branchId != null ? int.tryParse(branchId) : null,
      },
    );

    return EmployeeModel.fromMap(
      result.first.toColumnMap(),
    );
  }

  // =========================================================
  // UPDATE EMPLOYEE
  // =========================================================

  Future<EmployeeModel?> updateEmployee({
    required String id,
    String? fullName,
    String? email,
    String? employeeId,
    String? phone,
    String? role,
    String? roleId,
    String? type,
    String? branchId,
  }) async {
    final result = await  postgresService.connection.execute(
      Sql.named('''
        UPDATE employees
        SET
          full_name = COALESCE(@fullName, full_name),
          email = COALESCE(@email, email),
          employee_id = COALESCE(@employeeId, employee_id),
          phone = COALESCE(@phone, phone),
          role = COALESCE(@role, role),
          branch_id = COALESCE(@branchId, branch_id)
        WHERE id = @id
        RETURNING
          id,
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          is_verified,
          first_login,
          role,
          branch_id
      '''),
      parameters: {
        'id': id,
        'fullName': fullName,
        'email': email,
        'employeeId': employeeId,
        'phone': phone,
        'role': role,
        'branchId': branchId != null ? int.tryParse(branchId) : null,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    return EmployeeModel.fromMap(
      result.first.toColumnMap(),
    );
  }

  // =========================================================
  // DELETE EMPLOYEE
  // =========================================================

  Future<bool> deleteEmployee(String id) async {
    final result = await  postgresService.connection.execute(
      Sql.named('''
        DELETE FROM employees
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
      },
    );

    return result.affectedRows > 0;
  }
}
