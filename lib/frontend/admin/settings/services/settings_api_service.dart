import '/core/constants/api_constants.dart';
import '/core/network/api_client.dart';
import '../models/business_settings_model.dart';

class SettingsApiService {
  final ApiClient _client;

  SettingsApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<BusinessSettingsModel> getSettings() async {
    final data = await _client.get(ApiConstants.settings) as Map<String, dynamic>;
    return BusinessSettingsModel.fromJson(data);
  }

  Future<BusinessSettingsModel> updateSettings(BusinessSettingsModel settings) async {
    final data =
        await _client.put(ApiConstants.settings, settings.toRequestJson()) as Map<String, dynamic>;
    return BusinessSettingsModel.fromJson(data);
  }

  Future<BusinessSettingsModel> resetSettings() async {
    final data = await _client.post(ApiConstants.settingsReset, {}) as Map<String, dynamic>;
    return BusinessSettingsModel.fromJson(data);
  }
}