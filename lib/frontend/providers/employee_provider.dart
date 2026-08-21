import 'package:flutter/material.dart';
import 'package:erp_software/core/models/employee_model.dart';
import 'package:erp_software/frontend/services/employee_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeService _service = EmployeeService();

  List<EmployeeModel> _employees = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _roleFilter = 'All Roles';

  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get roleFilter => _roleFilter;

  List<EmployeeModel> get filteredEmployees {
    return _employees.where((emp) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = (emp.fullName?.toLowerCase().contains(query) ?? false) ||
          (emp.employeeId?.toLowerCase().contains(query) ?? false) ||
          (emp.email.toLowerCase().contains(query)) ||
          (emp.displayBranch.toLowerCase().contains(query));

      final matchesRole = _roleFilter == 'All Roles' || _roleFilter == 'All' ||
          (emp.role?.toLowerCase() == _roleFilter.toLowerCase());

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

  Future<void> fetchEmployees() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _employees = await _service.getEmployees();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEmployee(String id) async {
    try {
      await _service.deleteEmployee(id);
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
