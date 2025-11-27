import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductApi {
  static const String _baseUrl = "http://26.246.241.197:8081/api/productos";

  // 🔹 Obtener todos los productos
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // 🔥 Obtener productos por categoría
  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
  final url = "$_baseUrl/categoria/$categoryId";  // La URL correcta para productos por categoría
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load products by category");
  }
}

}
