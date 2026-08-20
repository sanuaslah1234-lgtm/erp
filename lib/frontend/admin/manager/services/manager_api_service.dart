import '/core/constants/api_constants.dart';
import '/core/network/api_client.dart';
import '../models/manager_model.dart';

class ManagerApiService {
  final ApiClient _client;

  ManagerApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<ManagerModel>> getManagers() async {
    final data = await _client.get(ApiConstants.managers) as List<dynamic>;
    return data.map((e) => ManagerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ManagerModel> createManager(ManagerModel manager, String password) async {
    final data = await _client.post(
      ApiConstants.managers,
      manager.toRequestJson(password: password),
    ) as Map<String, dynamic>;
    return ManagerModel.fromJson(data);
  }

  Future<ManagerModel> updateManager(int id, ManagerModel manager, {String password = ''}) async {
    final data = await _client.put(
      '${ApiConstants.managers}/$id',
      manager.toRequestJson(password: password),
    ) as Map<String, dynamic>;
    return ManagerModel.fromJson(data);
  }

  Future<void> deleteManager(int id) async {
    await _client.delete('${ApiConstants.managers}/$id');
  }
}