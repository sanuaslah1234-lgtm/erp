import 'package:postgres/postgres.dart';

class PostgresService {
  Connection? _connection;

  Future<void> connect() async {
    if (_connection != null) return;

    _connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'Erp',
        username: 'postgres',
        password: 'Aslah123',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    ); 

    print('✅ PostgreSQL Connected');
  }

  Connection get connection {
    if (_connection == null) {
      throw StateError(
        'PostgreSQL is not connected. Call connect() first.',
      );
    }

    return _connection!;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final result = await connection.execute(
      '''
      SELECT id, name, email, role, created_at
      FROM users
      ORDER BY id
      '''
    );

    return result.map((row) {
      return {
        'id': row[0],
        'name': row[1],
        'email': row[2],
        'role': row[3],
        'created_at': row[4]?.toString(),
      };
    }).toList();
  }
}