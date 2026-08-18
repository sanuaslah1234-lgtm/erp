import '/core/constants/api_constants.dart';
import '/core/network/api_client.dart';
import '../models/branch_model.dart';

class BranchApiService {
  final ApiClient _client;

  BranchApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<BranchModel>> getBranches() async {
    final data = await _client.get(ApiConstants.branches) as List<dynamic>;
    return data
        .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BranchModel> getBranchById(int id) async {
    final data =
        await _client.get('${ApiConstants.branches}/$id') as Map<String, dynamic>;
    return BranchModel.fromJson(data);
  }

  Future<BranchModel> createBranch(BranchModel branch) async {
    final data = await _client.post(
      ApiConstants.branches,
      branch.toRequestJson(),
    ) as Map<String, dynamic>;
    return BranchModel.fromJson(data);
  }

  Future<BranchModel> updateBranch(int id, BranchModel branch) async {
    final data = await _client.put(
      '${ApiConstants.branches}/$id',
      branch.toRequestJson(),
    ) as Map<String, dynamic>;
    return BranchModel.fromJson(data);
  }

  Future<void> deleteBranch(int id) async {
    await _client.delete('${ApiConstants.branches}/$id');
  }
}