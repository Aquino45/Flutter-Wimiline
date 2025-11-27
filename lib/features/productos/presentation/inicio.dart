import 'package:flutter/material.dart';
import 'package:proyecto/core/widgets/Product_Card.dart';

import 'package:proyecto/core/widgets/Search_Bar.dart';
import 'package:proyecto/core/widgets/carousel.dart';
import 'package:proyecto/features/productos/data/product_api.dart';
import 'package:proyecto/features/productos/data/product_model.dart';
import 'package:proyecto/features/productos/presentation/product_detail_page.dart'; // Asegúrate de importar tu SearchBar

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductApi().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Plus'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3F4F6), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 SearchBar fija arriba
              SearchBar1(
                controller: _searchController,
                onChanged: (query) {
                  print("Búsqueda: $query");
                },
              ),

              const SizedBox(height: 12),

              // ⬇️ Todo lo demás scrolleable (carousel + productos)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const ImageCarousel(),
                      const SizedBox(height: 20),

                      // 🛒 Productos
                      FutureBuilder<List<Product>>(
                        future: _products,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            final products = snapshot.data!;

                            // 👉 calculamos altura fija del ítem según el ancho
                            final width = MediaQuery.of(context).size.width;
                            final bool isWide = width > 600;
                            final double itemHeight = isWide
                                ? 190
                                : 220; // ajusta si quieres

                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,

                                    mainAxisExtent: itemHeight,
                                  ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailPage(product: product),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('No products available'),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
