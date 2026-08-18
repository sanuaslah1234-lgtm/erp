import 'package:erp_software/backend/services/jwt_service.dart';
import 'package:erp_software/core/constants/api_constants.dart';
import 'package:erp_software/core/utils/response_formatter.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware({List<String> allowedRoles = const []}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers[ApiConstants.authHeader];

      if (authHeader == null || !authHeader.startsWith(ApiConstants.bearerPrefix)) {
        return ResponseFormatter.error(
          message: 'Missing or invalid Authorization header',
          statusCode: 401,
        );
      }

      final token = authHeader.substring(ApiConstants.bearerPrefix.length).trim();
      final payload = JwtService.verifyToken(token);

      if (payload == null) {
        return ResponseFormatter.error(
          message: 'Invalid or expired JWT token',
          statusCode: 401,
        );
      }

      if (allowedRoles.isNotEmpty && !allowedRoles.contains(payload.role.toLowerCase())) {
        return ResponseFormatter.error(
          message: 'Forbidden: Insufficient privileges for this role',
          statusCode: 403,
        );
      }

      final updatedRequest = request.change(context: {
        'user': payload,
      });

      return await innerHandler(updatedRequest);
    };
  };
}
