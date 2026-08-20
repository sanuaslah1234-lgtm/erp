import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

class PostgresService {
  late Connection connection;

  Future<void> connect() async{
    final env = DotEnv()..load();

    connection = await Connection.open(
      Endpoint(
     host: env['DATABASE_HOST']!,
      port:int.parse(env['DATABASE_PORT']!),
      database: env['DATABASE_NAME']!,
      username: env['DATABASE_USER']!,
      password: env['DATABASE_PASSWORD']!,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable
      )
    );

    print("PostgreSQL connected successfully");


  }
  Future<void> close()async{
    await connection.close();
  }
}