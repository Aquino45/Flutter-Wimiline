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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Mismo fondo que Inicio
      body: Column(
        children: [
          // 🟣 ENCABEZADO FIJO (Consistente con Inicio)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Explora nuestro",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple.shade100,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Catálogo",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ⬇️ LISTA DE CATEGORÍAS
          Expanded(
            child: FutureBuilder<List<CategoryModel>>(
              future: _categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay categorías disponibles'));
                }

                final categories = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Padding inferior extra para el nav bar
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CategoryCard(
                        category: category,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryProductsPage(
                                categoryId: category.id,
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
        ],
      ),
    );
  }
} 