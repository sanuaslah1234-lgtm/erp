import 'package:erp_software/backend/database/postgres_service.dart';
import 'package:postgres/postgres.dart';

import '../models/employee_model.dart';

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
          plain_password,
          is_verified,
          first_login,
          verification_token,
          verification_expires,
          role,
          role_id,
          type,
          branch_id
        FROM users
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
          plain_password,
          is_verified,
          first_login,
          verification_token,
          verification_expires,
          role,
          role_id,
          type,
          branch_id
        FROM users
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
        INSERT INTO users (
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          is_verified,
          first_login,
          role,
          role_id,
          type,
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
          @roleId,
          @type,
          @branchId
        )
        RETURNING
          id,
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          plain_password,
          is_verified,
          first_login,
          verification_token,
          verification_expires,
          role,
          role_id,
          type,
          branch_id
      '''),
      parameters: {
        'fullName': fullName,
        'email': email,
        'employeeId': employeeId,
        'phone': phone,
        'passwordHash': passwordHash,
        'role': role,
        'roleId': roleId,
        'type': type,
        'branchId': branchId,
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
        UPDATE users
        SET
          full_name = COALESCE(@fullName, full_name),
          email = COALESCE(@email, email),
          employee_id = COALESCE(@employeeId, employee_id),
          phone = COALESCE(@phone, phone),
          role = COALESCE(@role, role),
          role_id = COALESCE(@roleId, role_id),
          type = COALESCE(@type, type),
          branch_id = COALESCE(@branchId, branch_id)
        WHERE id = @id
        RETURNING
          id,
          full_name,
          email,
          employee_id,
          phone,
          password_hash,
          plain_password,
          is_verified,
          first_login,
          verification_token,
          verification_expires,
          role,
          role_id,
          type,
          branch_id
      '''),
      parameters: {
        'id': id,
        'fullName': fullName,
        'email': email,
        'employeeId': employeeId,
        'phone': phone,
        'role': role,
        'roleId': roleId,
        'type': type,
        'branchId': branchId,
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
        DELETE FROM users
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
      },
    );

    return result.affectedRows > 0;
  }
}