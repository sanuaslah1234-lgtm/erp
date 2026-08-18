import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

class PostgresService {
  late Connection connection;

  Future<void> connect() async {
    final env = DotEnv()..load();

    final host = env['DB_HOST'];
    final port = env['DB_PORT'];
    final database = env['DB_NAME'];
    final username = env['DB_USER'];
    final password = env['DB_PASSWORD'];

    // Check missing environment variables
    if (host == null ||
        port == null ||
        database == null ||
        username == null ||
        password == null) {
      throw Exception(
        'PostgreSQL configuration is missing in .env file.\n'
        'Required: DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD',
      );
    }

    connection = await Connection.open(
      Endpoint(
        host: host,
        port: int.parse(port),
        database: database,
        username: username,
        password: password,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );

    stdout.writeln('PostgreSQL connected successfully');
  }

  Future<void> close() async {
    await connection.close();
  }

  // CREATE EMPLOYEE
  Future<Map<String, dynamic>> createEmployee(
    Map<String, dynamic> data,
  ) async {
    final result = await connection.execute(
      Sql.named('''
        INSERT INTO employees (
          employee_id,
          full_name,
          email,
          phone,
          role,
          password,
          is_verified
        )
        VALUES (
          @employee_id,
          @full_name,
          @email,
          @phone,
          @role,
          @password,
          @is_verified
        )
        RETURNING
          id,
          employee_id,
          full_name,
          email,
          phone,
          role,
          is_verified,
          created_at,
          updated_at
      '''),
      parameters: {
        'employee_id': data['employee_id'],
        'full_name': data['full_name'],
        'email': data['email'],
        'phone': data['phone'],
        'role': data['role'],
        'password': data['password'],
        'is_verified': data['is_verified'] ?? true,
      },
    );

    final row = result.first;

    return {
      'id': row[0],
      'employee_id': row[1],
      'full_name': row[2],
      'email': row[3],
      'phone': row[4],
      'role': row[5],
      'is_verified': row[6],
      'created_at': row[7]?.toString(),
      'updated_at': row[8]?.toString(),
    };
  }

  // GET ALL EMPLOYEES
  Future<List<Map<String, dynamic>>> getEmployees() async {
    final result = await connection.execute('''
      SELECT
        id,
        employee_id,
        full_name,
        email,
        phone,
        role,
        is_verified,
        created_at,
        updated_at
      FROM employees
      ORDER BY id DESC
    ''');

    return result.map((row) {
      return {
        'id': row[0],
        'employee_id': row[1],
        'full_name': row[2],
        'email': row[3],
        'phone': row[4],
        'role': row[5],
        'is_verified': row[6],
        'created_at': row[7]?.toString(),
        'updated_at': row[8]?.toString(),
      };
    }).toList();
  }

  // GET EMPLOYEE BY ID
  Future<Map<String, dynamic>?> getEmployeeById(int id) async {
    final result = await connection.execute(
      Sql.named('''
        SELECT
          id,
          employee_id,
          full_name,
          email,
          phone,
          role,
          is_verified,
          created_at,
          updated_at
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

    final row = result.first;

    return {
      'id': row[0],
      'employee_id': row[1],
      'full_name': row[2],
      'email': row[3],
      'phone': row[4],
      'role': row[5],
      'is_verified': row[6],
      'created_at': row[7]?.toString(),
      'updated_at': row[8]?.toString(),
    };
  }

  // UPDATE EMPLOYEE
  Future<Map<String, dynamic>?> updateEmployee(
    int id,
    Map<String, dynamic> data,
  ) async {
    final result = await connection.execute(
      Sql.named('''
        UPDATE employees
        SET
          employee_id = @employee_id,
          full_name = @full_name,
          email = @email,
          phone = @phone,
          role = @role,
          is_verified = @is_verified,
          updated_at = CURRENT_TIMESTAMP
        WHERE id = @id
        RETURNING
          id,
          employee_id,
          full_name,
          email,
          phone,
          role,
          is_verified,
          created_at,
          updated_at
      '''),
      parameters: {
        'id': id,
        'employee_id': data['employee_id'],
        'full_name': data['full_name'],
        'email': data['email'],
        'phone': data['phone'],
        'role': data['role'],
        'is_verified': data['is_verified'] ?? true,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    final row = result.first;

    return {
      'id': row[0],
      'employee_id': row[1],
      'full_name': row[2],
      'email': row[3],
      'phone': row[4],
      'role': row[5],
      'is_verified': row[6],
      'created_at': row[7]?.toString(),
      'updated_at': row[8]?.toString(),
    };
  }

  // DELETE EMPLOYEE
  Future<bool> deleteEmployee(int id) async {
    final result = await connection.execute(
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