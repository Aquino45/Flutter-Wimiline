import 'package:flutter/material.dart';
import 'package:proyecto/core/widgets/Product_Card.dart';
import 'package:proyecto/features/productos/data/product_api.dart';
import 'package:proyecto/features/productos/data/product_model.dart';
import 'package:proyecto/features/productos/presentation/product_detail_page.dart';


class CategoryProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductApi().fetchProductsByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay productos en esta categoría"));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ProductCard(product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
                );
            },
          );
        },
      ),
    );
  }
}
