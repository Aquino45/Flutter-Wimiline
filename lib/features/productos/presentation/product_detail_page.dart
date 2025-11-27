import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/features/productos/data/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Fondo gris muy suave y moderno

      // AppBar limpio y blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Detalle del Producto",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 17),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Column(
        children: [
          // CONTENIDO SCROLLEABLE
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼 1. SECCIÓN DE IMAGEN DESTACADA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12, // Sombra suave hacia abajo
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: product.imagenUrl, // Efecto de transición suave desde la lista
                      child: CachedNetworkImage(
                        imageUrl: product.imagenUrl,
                        height: 280,
                        fit: BoxFit.contain,
                        
                        // Widget de carga (Spinner)
                        progressIndicatorBuilder: (context, url, downloadProgress) {
                          return Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                strokeWidth: 3,
                                color: Colors.deepPurple,
                              ),
                            ),
                          );
                        },

                        // Widget de error (Si falla la carga)
                        errorWidget: (context, url, error) => Container(
                          height: 280,
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Imagen no disponible", style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 📝 2. INFORMACIÓN DEL PRODUCTO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          product.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Fila de Precio y Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Precio
                            Text(
                              "\$${product.precio.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.deepPurple,
                              ),
                            ),
                            
                            // Chip de Stock (Verde o Rojo)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: product.stock > 0 ? Colors.green.shade50 : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: product.stock > 0 ? Colors.green.shade200 : Colors.red.shade200
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    product.stock > 0 ? Icons.check_circle : Icons.cancel,
                                    size: 18,
                                    color: product.stock > 0 ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    product.stock > 0 ? "Stock: ${product.stock}" : "Agotado",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: product.stock > 0 ? Colors.green.shade700 : Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Descripción
                        if (product.descripcion != null && product.descripcion!.trim().isNotEmpty) ...[
                          const Text(
                            "Descripción",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.descripcion!,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Detalles Técnicos (en tarjeta blanca)
                        if (product.detalles != null && product.detalles!.trim().isNotEmpty) ...[
                          const Text(
                            "Especificaciones",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              product.detalles!,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 40), // Espacio extra al final
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🛒 3. BOTÓN INFERIOR FLOTANTE (Fixed Bottom Bar)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(55), // Botón alto y cómodo
                  elevation: 5,
                  shadowColor: Colors.deepPurple.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(child: Text("${product.nombre} agregado al carrito")),
                        ],
                      ),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: const Text(
                  "Agregar al Carrito",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}