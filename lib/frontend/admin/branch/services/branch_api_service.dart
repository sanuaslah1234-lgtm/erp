import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:erp_software/frontend/admin/branch/models/branch_model.dart';

class BranchApiService {
  // ============================================================
  // API BASE URL
  // ============================================================

  static const String baseUrl = 'http://localhost:5000';

  // ============================================================
  // HEADERS
  // ============================================================

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ============================================================
  // GET ALL BRANCHES
  // ============================================================

  Future<List<BranchModel>> getBranches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/branches'),
      headers: _headers,
    );

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }

    final data = decoded['data'];

    if (data is! List) {
      throw Exception('Invalid branch data');
    }

    return data.map<BranchModel>((item) {
      return BranchModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // ============================================================
  // GET BRANCH BY ID
  // ============================================================

  Future<BranchModel> getBranchById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/branches/$id'),
      headers: _headers,
    );

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }

    final data = decoded['data'];

    if (data is! Map) {
      throw Exception('Branch not found');
    }

    return BranchModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // ============================================================
  // CREATE BRANCH
  // ============================================================

  Future<BranchModel> createBranch(
    BranchModel branch,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/branches'),
      headers: _headers,
      body: jsonEncode({
        'code': branch.code,
        'name': branch.name,
        'address': branch.address,
        'city': branch.city,
        'state': branch.state,
        'phone': branch.phone,
        'email': branch.email,
        'is_active': branch.isActive,
      }),
    );

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }

    final data = decoded['data'];

    if (data is! Map) {
      throw Exception('Invalid created branch data');
    }

    return BranchModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // ============================================================
  // UPDATE BRANCH
  // ============================================================

  Future<BranchModel> updateBranch(
    int id,
    BranchModel branch,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/branches/$id'),
      headers: _headers,
      body: jsonEncode({
        'code': branch.code,
        'name': branch.name,
        'address': branch.address,
        'city': branch.city,
        'state': branch.state,
        'phone': branch.phone,
        'email': branch.email,
        'is_active': branch.isActive,
      }),
    );

    _checkResponse(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }

    final data = decoded['data'];

    if (data is! Map) {
      throw Exception('Invalid updated branch data');
    }

    return BranchModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // ============================================================
  // DELETE BRANCH
  // ============================================================

  Future<void> deleteBranch(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/branches/$id'),
      headers: _headers,
    );

    _checkResponse(response);
  }

  // ============================================================
  // RESPONSE VALIDATION
  // ============================================================

  void _checkResponse(http.Response response) {
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    String message = 'Something went wrong';

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final serverMessage = decoded['message'];

        if (serverMessage != null) {
          message = serverMessage.toString();
        }
      }
    } catch (_) {
      // Keep default message.
    }

    throw Exception(
      'API Error ${response.statusCode}: $message',
    );
  }
}

