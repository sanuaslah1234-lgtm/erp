import 'dart:io';

// import 'package:postgres/postgres.dart';

import 'postgres_service.dart';

class MigrationRunner {
  final PostgresService postgresService;

  MigrationRunner(this.postgresService);

  Future<void> runMigrations() async {
    final migrationDirectory = Directory(
      'lib/backend/database/migrations',
    );

    if (!migrationDirectory.existsSync()) {
      print('Migration directory not found.');
      return;
    }

    final files = migrationDirectory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.sql'))
        .toList();

    files.sort(
      (a, b) => a.path.compareTo(b.path),
    );

    for (final file in files) {
      print('Running migration: ${file.path}');

      final sql = await file.readAsString();

      // Split SQL statements
      final statements = sql
          .split(';')
          .map((statement) => statement.trim())
          .where((statement) => statement.isNotEmpty)
          .toList();

      for (final statement in statements) {
        await postgresService.connection.execute(
          statement,
        );
      }

      print('Migration completed: ${file.path}');
    }

    print('All migrations completed.');
  }
}