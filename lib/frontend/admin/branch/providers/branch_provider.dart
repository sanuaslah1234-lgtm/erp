import 'package:flutter/foundation.dart';

import 'package:erp_software/frontend/admin/branch/models/branch_model.dart';
import 'package:erp_software/frontend/admin/branch/services/branch_api_service.dart';

class BranchProvider extends ChangeNotifier {
  final BranchApiService _apiService;

  BranchProvider({
    BranchApiService? apiService,
  }) : _apiService = apiService ?? BranchApiService();

  // ============================================================
  // STATE
  // ============================================================

  List<BranchModel> _branches = [];

  bool _isLoading = false;
  bool _isSaving = false;

  String? _errorMessage;

  // ============================================================
  // GETTERS
  // ============================================================

  List<BranchModel> get branches => List.unmodifiable(_branches);

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  // ============================================================
  // FETCH ALL BRANCHES
  // ============================================================

  Future<void> fetchBranches() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _branches = await _apiService.getBranches();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH BRANCH BY ID
  // ============================================================

  Future<BranchModel?> fetchBranchById(int id) async {
    _errorMessage = null;

    try {
      return await _apiService.getBranchById(id);
    } catch (e) {
      _errorMessage = _cleanError(e);

      notifyListeners();

      return null;
    }
  }

  // ============================================================
  // CREATE BRANCH
  // ============================================================

  Future<bool> createBranch(BranchModel branch) async {
    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final createdBranch = await _apiService.createBranch(branch);

      _branches = [
        createdBranch,
        ..._branches,
      ];

      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);

      return false;
    } finally {
      _isSaving = false;

      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE BRANCH
  // ============================================================

  Future<bool> updateBranch(
    int id,
    BranchModel branch,
  ) async {
    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final updatedBranch = await _apiService.updateBranch(
        id,
        branch,
      );

      final index = _branches.indexWhere(
        (item) => item.id == id,
      );

      if (index != -1) {
        final updatedBranches =
            List<BranchModel>.from(_branches);

        updatedBranches[index] = updatedBranch;

        _branches = updatedBranches;
      }

      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);

      return false;
    } finally {
      _isSaving = false;

      notifyListeners();
    }
  }

  // ============================================================
  // DELETE BRANCH
  // ============================================================

  Future<bool> deleteBranch(int id) async {
    _errorMessage = null;

    try {
      await _apiService.deleteBranch(id);

      _branches = _branches
          .where((branch) => branch.id != id)
          .toList();

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // SEARCH BRANCHES
  // ============================================================

  List<BranchModel> searchBranches(String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return branches;
    }

    return _branches.where((branch) {
      return branch.code.toLowerCase().contains(searchQuery) ||
          branch.name.toLowerCase().contains(searchQuery) ||
          branch.address.toLowerCase().contains(searchQuery) ||
          branch.city.toLowerCase().contains(searchQuery) ||
          branch.state.toLowerCase().contains(searchQuery) ||
          branch.phone.toLowerCase().contains(searchQuery) ||
          branch.email.toLowerCase().contains(searchQuery);
    }).toList();
  }

  // ============================================================
  // ACTIVE BRANCHES
  // ============================================================

  List<BranchModel> get activeBranches {
    return _branches
        .where((branch) => branch.isActive)
        .toList();
  }

  // ============================================================
  // INACTIVE BRANCHES
  // ============================================================

  List<BranchModel> get inactiveBranches {
    return _branches
        .where((branch) => !branch.isActive)
        .toList();
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // CLEAR BRANCHES
  // ============================================================

  void clearBranches() {
    _branches = [];
    notifyListeners();
  }

  // ============================================================
  // ERROR CLEANER
  // ============================================================

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}

