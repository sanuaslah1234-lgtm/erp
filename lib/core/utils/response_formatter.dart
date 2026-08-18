import 'dart:convert';
import 'package:shelf/shelf.dart';

class ResponseFormatter {
  static Response success({
    required String message,
    dynamic data,
    int statusCode = 200,
  }) {
    return Response(
      statusCode,
      body: jsonEncode({
        'success': true,
        'message': message,
        'data': data ?? {},
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  static Response error({
    required String message,
    int statusCode = 400,
    dynamic error,
  }) {
    return Response(
      statusCode,
      body: jsonEncode({
        'success': false,
        'message': message,
        if (error != null) 'error': error.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
