import '../models/sales_record_model.dart';
import '../models/sales_summary_model.dart';

class SalesReportResult {
  final SalesSummaryModel summary;
  final List<SalesRecordModel> records;

  const SalesReportResult({required this.summary, required this.records});
}