import 'dart:convert';
import 'package:erp_software/backend/models/cashier/cashier_settings_model.dart';
import 'package:erp_software/backend/services/cashier/cashier_settings_service.dart';
import 'package:erp_software/core/errors/api_exception.dart';
import 'package:erp_software/core/utils/response_formatter.dart';
import 'package:shelf/shelf.dart';

class CashierSettingsController {
  final CashierSettingsService settingsService;

  CashierSettingsController(this.settingsService);

  Future<Response> getSettings(Request request) async {
    try {
      final settings = await settingsService.getSettings();
      return ResponseFormatter.success(
        message: 'Cashier settings fetched successfully',
        data: settings.toJson(),
      );
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to fetch cashier settings', statusCode: 500, error: e);
    }
  }

  Future<Response> updateSettings(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      if (bodyStr.isEmpty) {
        return ResponseFormatter.error(message: 'Request body cannot be empty', statusCode: 400);
      }

      final body = jsonDecode(bodyStr) as Map<String, dynamic>;
      final model = CashierSettingsModel.fromJson(body);

      final updated = await settingsService.updateSettings(model);

      return ResponseFormatter.success(
        message: 'Cashier settings updated successfully!',
        data: updated.toJson(),
      );
    } on ApiException catch (e) {
      return ResponseFormatter.error(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to update cashier settings', statusCode: 500, error: e);
    }
  }
}
