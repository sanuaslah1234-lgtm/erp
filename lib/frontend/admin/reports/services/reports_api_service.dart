import '/core/constants/api_constants.dart';
import '/core/network/api_client.dart';
import '../models/inventory_record_model.dart';
import '../models/inventory_report_result.dart';
import '../models/inventory_summary_model.dart';
import '../models/purchase_record_model.dart';
import '../models/purchase_report_result.dart';
import '../models/purchase_summary_model.dart';
import '../models/sales_record_model.dart';
import '../models/sales_report_results.dart';
import '../models/sales_summary_model.dart';

class ReportsApiService {
  final ApiClient _client;

  ReportsApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<SalesReportResult> getSalesReport({
    required DateTime from,
    required DateTime to,
    String? customer,
    String? search,
  }) async {
    final query = {
      'from': _formatDate(from),
      'to': _formatDate(to),
      if (customer != null && customer.isNotEmpty && customer != 'All Customers')
        'customer': customer,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse(ApiConstants.salesReport).replace(queryParameters: query);
    final data = await _client.get(uri.toString()) as Map<String, dynamic>;

    final summary = SalesSummaryModel.fromJson(data['summary'] as Map<String, dynamic>);
    final records = (data['records'] as List<dynamic>)
        .map((e) => SalesRecordModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SalesReportResult(summary: summary, records: records);
  }

  Future<List<String>> getCustomers() async {
    final data = await _client.get(ApiConstants.reportCustomers) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<PurchaseReportResult> getPurchaseReport({
    required DateTime from,
    required DateTime to,
    String? supplier,
    String? search,
  }) async {
    final query = {
      'from': _formatDate(from),
      'to': _formatDate(to),
      if (supplier != null && supplier.isNotEmpty && supplier != 'All Suppliers')
        'supplier': supplier,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse(ApiConstants.purchaseReport).replace(queryParameters: query);
    final data = await _client.get(uri.toString()) as Map<String, dynamic>;

    final summary = PurchaseSummaryModel.fromJson(data['summary'] as Map<String, dynamic>);
    final records = (data['records'] as List<dynamic>)
        .map((e) => PurchaseRecordModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PurchaseReportResult(summary: summary, records: records);
  }

  Future<List<String>> getSuppliers() async {
    final data = await _client.get(ApiConstants.reportSuppliers) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<InventoryReportResult> getInventoryReport({
    String? category,
    String? search,
  }) async {
    final query = {
      if (category != null && category.isNotEmpty && category != 'All Categories')
        'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse(ApiConstants.inventoryReport).replace(queryParameters: query);
    final data = await _client.get(uri.toString()) as Map<String, dynamic>;

    final summary = InventorySummaryModel.fromJson(data['summary'] as Map<String, dynamic>);
    final records = (data['records'] as List<dynamic>)
        .map((e) => InventoryRecordModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return InventoryReportResult(summary: summary, records: records);
  }

  Future<List<String>> getCategories() async {
    final data = await _client.get(ApiConstants.reportCategories) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}