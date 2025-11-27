import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/features/carrito/data/carrito_service.dart';
import 'package:proyecto/features/productos/data/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[300] : Colors.grey[700];

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detalle del Producto",
          style: TextStyle(
            color: textColor, 
            fontWeight: FontWeight.w600, 
            fontSize: 17
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 1. CAPA DE FONDO Y CONTENIDO (Scrollable)
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 SECCIÓN DE IMAGEN
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 110, 20, 40),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                    gradient: isDarkMode 
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.deepPurple.shade900, backgroundColor],
                          )
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.white],
                          ),
                    boxShadow: [
                      if (!isDarkMode)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                    ],
                  ),
                  child: Hero(
                    tag: product.imagenUrl,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: product.imagenUrl,
                        height: 280,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress, 
                            color: primaryColor
                          )
                        ),
                        errorWidget: (context, url, error) => 
                          Icon(Icons.image_not_supported_outlined, size: 50, color: subTextColor),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 📝 INFORMACIÓN DEL PRODUCTO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        product.nombre,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // Precio y Stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.precio.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: isDarkMode ? Colors.deepPurpleAccent.shade100 : primaryColor,
                            ),
                          ),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: product.stock > 0 
                                  ? (isDarkMode ? Colors.green.withOpacity(0.2) : Colors.green.shade50)
                                  : (isDarkMode ? Colors.red.withOpacity(0.2) : Colors.red.shade50),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: product.stock > 0 
                                    ? (isDarkMode ? Colors.greenAccent.withOpacity(0.5) : Colors.green.shade200)
                                    : (isDarkMode ? Colors.redAccent.withOpacity(0.5) : Colors.red.shade200)
                              ),
                            ),
                            child: Text(
                              product.stock > 0 ? "Stock: ${product.stock}" : "Agotado",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: product.stock > 0 
                                    ? (isDarkMode ? Colors.greenAccent : Colors.green.shade700)
                                    : (isDarkMode ? Colors.redAccent : Colors.red.shade700),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Descripción
                      if (product.descripcion != null && product.descripcion!.trim().isNotEmpty) ...[
                        Text("Descripción", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Text(
                          product.descripcion!,
                          style: TextStyle(fontSize: 16, height: 1.5, color: subTextColor),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Especificaciones
                      if (product.detalles != null && product.detalles!.trim().isNotEmpty) ...[
                        Text("Especificaciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey.shade200),
                          ),
                          child: Text(
                            product.detalles!,
                            style: TextStyle(fontSize: 15, height: 1.4, color: subTextColor),
                          ),
                        ),
                      ],

                      const SizedBox(height: 100), 
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. CAPA DEL BOTÓN (Flotante abajo)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withOpacity(0.0),
                    backgroundColor.withOpacity(0.8),
                    backgroundColor,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // 🔥 FORZAMOS EL MORADO INTENSO (DeepPurple)
                  backgroundColor: Colors.deepPurple, 
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 8,
                  shadowColor: Colors.deepPurple.withOpacity(0.5), // Sombra acorde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                  onPressed: () {
                  // ✅ LLAMADA AL SERVICIO
                  CarritoService.instance.addToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(child: Text("${product.nombre} agregado")),
                        ],
                      ),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1), // Más rápido
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