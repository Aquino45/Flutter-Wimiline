import 'package:flutter/material.dart';
import 'package:proyecto/core/widgets/Category_Card.dart';

import 'package:proyecto/features/categorias/data/category_api.dart';
import 'package:proyecto/features/categorias/data/category_model.dart';
import 'package:proyecto/features/categorias/presentation/category_products_page.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  late Future<List<CategoryModel>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = CategoryApi().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3F4F6), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<CategoryModel>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay categorías'));
              }

              final categories = snapshot.data!;

              return ListView.builder(
  itemCount: categories.length,
  itemBuilder: (context, index) {
    final category = categories[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CategoryCard(
        category: category,
       onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CategoryProductsPage(
        categoryId: category.id, // Asegúrate de que `category.id` esté pasando correctamente
        categoryName: category.nombre,
      ),
    ),
  );
},

      ),
    );
  },
);

            },
          ),
        ),
      ),
    );
  }
}
