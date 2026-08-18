import 'dart:convert';
import 'package:erp_software/backend/services/cashier/barcode_service.dart';
import 'package:erp_software/backend/services/jwt_service.dart';
import 'package:erp_software/core/errors/api_exception.dart';
import 'package:erp_software/core/utils/response_formatter.dart';
import 'package:shelf/shelf.dart';

class BarcodeController {
  final BarcodeService barcodeService;

  BarcodeController(this.barcodeService);

  Future<Response> createBarcode(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      if (bodyStr.isEmpty) {
        return ResponseFormatter.error(message: 'Request body cannot be empty', statusCode: 400);
      }

      final body = jsonDecode(bodyStr) as Map<String, dynamic>;
      final user = request.context['user'] as JwtPayload?;
      final productId = int.tryParse(body['productId'].toString());
      final barcode = body['barcode']?.toString();
      final labelQuantity = int.tryParse(body['labelQuantity']?.toString() ?? '1') ?? 1;

      if (productId == null || barcode == null || barcode.isEmpty) {
        return ResponseFormatter.error(message: 'productId and barcode are required', statusCode: 400);
      }

      final record = await barcodeService.generateBarcodePrint(
        productId: productId,
        barcode: barcode,
        labelQuantity: labelQuantity,
        createdBy: user?.userId,
      );

      return ResponseFormatter.success(
        message: 'Barcode label print record created',
        data: record.toJson(),
      );
    } on ApiException catch (e) {
      return ResponseFormatter.error(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to record barcode print', statusCode: 500, error: e);
    }
  }

  Future<Response> getBarcodes(Request request) async {
    try {
      final barcodes = await barcodeService.getBarcodeHistory();
      return ResponseFormatter.success(
        message: 'Barcode print history fetched',
        data: barcodes.map((b) => b.toJson()).toList(),
      );
    } catch (e) {
      return ResponseFormatter.error(message: 'Failed to fetch barcode history', statusCode: 500, error: e);
    }
  }
}
