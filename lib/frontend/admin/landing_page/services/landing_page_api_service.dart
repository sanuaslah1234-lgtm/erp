import '/core/constants/api_constants.dart';
import '/core/network/api_client.dart';
import '../models/landing_page_model.dart';

class LandingPageApiService {
  final ApiClient _client;

  LandingPageApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<LandingPageModel> getSettings() async {
    final data = await _client.get(ApiConstants.landingPage) as Map<String, dynamic>;
    return LandingPageModel.fromJson(data);
  }

  Future<LandingPageModel> updateSettings(LandingPageModel settings) async {
    final data = await _client.put(
      ApiConstants.landingPage,
      settings.toRequestJson(),
    ) as Map<String, dynamic>;
    return LandingPageModel.fromJson(data);
  }

  Future<LandingPageModel> resetSettings() async {
    final data = await _client.post(ApiConstants.landingPageReset, {}) as Map<String, dynamic>;
    return LandingPageModel.fromJson(data);
  }
}