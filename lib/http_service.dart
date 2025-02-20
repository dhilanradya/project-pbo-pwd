import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post_model.dart';

class HttpService {
  final String baseUrl = "http://127.0.0.1:8000/api/products";

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> productList = jsonData['data'];
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products. Status code: ${response.statusCode}");
    }
  }
}