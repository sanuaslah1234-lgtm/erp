import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:erp_software/backend/database/postgres_service.dart';

class GetUserController {
  final PostgresService postgresService;

  GetUserController(this.postgresService);

  Future<Response> getUsers(Request request) async {
    try {
      final users = await postgresService.getUsers();

      return Response.ok(
        jsonEncode(users),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': e.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }
  }
}