

import 'package:proyecto/features/productos/data/product_api.dart';
import 'package:proyecto/features/productos/data/product_model.dart';

class ProductRepository {
  final ProductApi productApi;

  ProductRepository({required this.productApi});

  Future<List<Product>> getProducts() async {
    return await productApi.fetchProducts();
  }
}
