import 'dart:convert';
import 'package:http/http.dart' as http;

import 'category_model.dart';

class CategoryApi {
  static const String _baseUrl = 'http://26.246.241.197:8081/api/categorias';

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar categorías: ${response.statusCode}');
    }
  }
}
