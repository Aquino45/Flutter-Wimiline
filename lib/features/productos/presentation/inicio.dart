import 'package:flutter/material.dart';
import 'package:proyecto/core/widgets/Product_Card.dart';
import 'package:proyecto/core/widgets/Search_Bar.dart';
import 'package:proyecto/core/widgets/carousel.dart';
import 'package:proyecto/features/productos/data/product_api.dart';
import 'package:proyecto/features/productos/data/product_model.dart';
import 'package:proyecto/features/productos/presentation/product_detail_page.dart';
import 'package:proyecto/features/categorias/data/category_api.dart';
import 'package:proyecto/features/categorias/data/category_model.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController _searchController = TextEditingController();
  
  late Future<List<Product>> _productsFuture;
  late Future<List<CategoryModel>> _categoriesFuture;
  
  String _selectedCategoryId = 'todos'; 

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductApi().fetchProducts();
    _categoriesFuture = CategoryApi().fetchCategories();
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _searchController.clear();
      
      if (categoryId == 'todos') {
        _productsFuture = ProductApi().fetchProducts();
      } else {
        _productsFuture = ProductApi().fetchProductsByCategory(categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 600;
    final int crossAxisCount = isWide ? 3 : 2;
    final double mainAxisExtent = isWide ? 260 : 250; 

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: Column(
        children: [
          // 🟣 ENCABEZADO FIJO MORADO
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 15), 
            decoration: const BoxDecoration(
              color: Colors.deepPurple, 
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
                      "Buenos días, 👋",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple.shade100, 
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Wimiline",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), 
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),

          // ⬇️ CONTENIDO SCROLLEABLE
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // 🔍 BARRA DE BÚSQUEDA
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SearchBar1(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {});
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ImageCarousel(),
                  ),
                ),

                // 🏷 FILTROS DE CATEGORÍA
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: FutureBuilder<List<CategoryModel>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: [_buildCategoryChip("Todos", 'todos')],
                          );
                        }

                        final categories = snapshot.data!;
                        
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categories.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildCategoryChip("Todos", 'todos');
                            }
                            final cat = categories[index - 1];
                            return _buildCategoryChip(cat.nombre, cat.id);
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 25)),

                // 🛒 GRID DE PRODUCTOS
                FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text('Error al cargar: ${snapshot.error}'),
                          ),
                        ),
                      );
                    }

                    final allProducts = snapshot.data ?? [];
                    final searchText = _searchController.text.toLowerCase();
                    final displayProducts = allProducts.where((product) {
                      return product.nombre.toLowerCase().contains(searchText);
                    }).toList();

                    if (displayProducts.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.search_off, size: 50, color: Colors.grey),
                                const SizedBox(height: 10),
                                Text(
                                  searchText.isEmpty 
                                      ? 'No hay productos en esta categoría' 
                                      : 'No se encontraron productos',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: mainAxisExtent,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = displayProducts[index];
                            return ProductCard(
                              product: product,
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
                          childCount: displayProducts.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 WIDGET DE CHIP ACTUALIZADO PARA MODO OSCURO
  Widget _buildCategoryChip(String label, String id) {
    final bool isSelected = _selectedCategoryId == id;
    
    // Detectamos el modo oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colores dinámicos
    final chipBackground = isDarkMode ? const Color(0xFF2A2A2A) : Colors.white; // Gris moderno vs Blanco
    final textColor = isDarkMode ? Colors.white : Colors.grey[700]; // Blanco vs Gris oscuro
    final borderColor = isDarkMode ? Colors.transparent : Colors.grey.shade300;

    return Material(
      color: isSelected ? Colors.deepPurple : chipBackground, 
      borderRadius: BorderRadius.circular(20),
      elevation: isSelected ? 4 : 0,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      child: InkWell(
        onTap: () => _onCategorySelected(id),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: borderColor), 
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}