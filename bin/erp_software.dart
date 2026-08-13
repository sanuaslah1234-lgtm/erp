import 'package:erp_software/backend/database/controller/getUserController.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'package:erp_software/backend/database/postgres_service.dart';

final postgresService = PostgresService();

final router = Router();

Future<void> main() async {
  await postgresService.connect();

  final userController = GetUserController(postgresService);

  // router.get('/', (Request request) {
  //   return Response.ok('ERP Backend Running');
  // });

  router.get('/users', userController.getUsers);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    '0.0.0.0',
    5000,
  );

  print(
    'Server running on '
    'http://${server.address.host}:${server.port}',
  );
}