import 'package:flutter/material.dart';
import 'package:erp_software/frontend/models/employee_model.dart';
import 'package:erp_software/frontend/services/employee_api_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeApiService _apiService = EmployeeApiService();

  List<EmployeeModel> _employees = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _roleFilter = 'All';

  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get roleFilter => _roleFilter;

  List<EmployeeModel> get filteredEmployees {
    return _employees.where((emp) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = emp.fullName.toLowerCase().contains(query) ||
          emp.employeeId.toLowerCase().contains(query) ||
          (emp.user?.email.toLowerCase().contains(query) ?? false) ||
          (emp.department?.toLowerCase().contains(query) ?? false) ||
          (emp.designation?.toLowerCase().contains(query) ?? false);

      final matchesRole = _roleFilter == 'All' ||
          (emp.user?.role.toLowerCase() == _roleFilter.toLowerCase());

      return matchesSearch && matchesRole;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setRoleFilter(String role) {
    _roleFilter = role;
    notifyListeners();
  }

  Future<void> fetchEmployees(String? token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _employees = await _apiService.getEmployees(token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addEmployee(String? token, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newEmp = await _apiService.createEmployee(token, data);
      _employees.insert(0, newEmp);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEmployee(String? token, int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _apiService.updateEmployee(token, id, data);
      final index = _employees.indexWhere((e) => e.id == id);
      if (index != -1) {
        _employees[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Local fallback edit
      final index = _employees.indexWhere((e) => e.id == id);
      if (index != -1) {
        final existing = _employees[index];
        _employees[index] = existing.copyWith(
          employeeId: data['employee_id'] ?? existing.employeeId,
          fullName: data['full_name'] ?? existing.fullName,
          phone: data['phone'] ?? existing.phone,
          department: data['department'] ?? existing.department,
          designation: data['designation'] ?? existing.designation,
          isVerified: data['is_verified'] ?? existing.isVerified,
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> toggleStatus(String? token, int id, bool isActive) async {
    try {
      await _apiService.toggleStatus(token, id, isActive);
      final index = _employees.indexWhere((e) => e.id == id);
      if (index != -1) {
        final existing = _employees[index];
        if (existing.user != null) {
          _employees[index] = existing.copyWith(
            user: existing.user!.role.isEmpty
                ? existing.user
                : existing.user!.toJson()['role'] != null
                    ? existing.user
                    : existing.user,
          );
        }
      }
      await fetchEmployees(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEmployee(String? token, int id) async {
    try {
      await _apiService.deleteEmployee(token, id);
      _employees.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
