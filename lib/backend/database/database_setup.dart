import 'package:postgres/postgres.dart';

class DatabaseSetup {
  final Connection db;
  DatabaseSetup(this.db);

  Future<void> createTables() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories(
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) UNIQUE NOT NULL,
        description TEXT,
        status VARCHAR(30) DEFAULT 'active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
''');
print("Categories table created");
  }
}
  