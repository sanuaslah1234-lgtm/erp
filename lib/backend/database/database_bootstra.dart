// import 'package:dotenv/dotenv.dart';
// import 'package:postgres/postgres.dart';

// class DatabaseBootstrap {
//   Future<void> createDatabase() async {
//     final env = DotEnv(
//       includePlatformEnvironment: true,
//     )..load();

//     final host = env['DATABASE_HOST']!;
//     final port = int.parse(
//       env['DATABASE_PORT']!,
//     );

//     final databaseName =
//         env['DATABASE_NAME']!;

//     final username =
//         env['DATABASE_USER']!;

//     final password =
//         env['DATABASE_PASSWORD']!;

//     // Connect to PostgreSQL default database
//     final connection = await Connection.open(
//       Endpoint(
//         host: host,
//         port: port,
//         database: 'postgres',
//         username: username,
//         password: password,
//       ),
//       settings: const ConnectionSettings(
//         sslMode: SslMode.disable,
//       ),
//     );

//     try {
//       final result = await connection.execute(
//         Sql.named('''
//           SELECT 1
//           FROM pg_database
//           WHERE datname = @databaseName
//         '''),
//         parameters: {
//           'databaseName': databaseName,
//         },
//       );

//       if (result.isEmpty) {
//         await connection.execute(
//           'CREATE DATABASE "$databaseName"',
//         );

//         print(
//           '✅ Database "$databaseName" created',
//         );
//       } else {
//         print(
//           '✅ Database "$databaseName" already exists',
//         );
//       }
//     } finally {
//       await connection.close();
//     }
//   }
// }