import 'dart:convert';

import 'package:erp_software/main.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  static const String baseUrl = ApiConfig.baseUrl;

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch products: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    final List<dynamic> data;

    if (decoded is List) {
      data = decoded;
    } else if (decoded is Map &&
        decoded['data'] is List) {
      data = decoded['data'];
    } else {
      throw Exception(
        'Invalid products response',
      );
    }

    return data
        .map(
          (json) => ProductModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }
}