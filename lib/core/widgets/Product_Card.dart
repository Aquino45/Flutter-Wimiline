import 'package:flutter/material.dart';
import '../../features/productos/data/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos un placeholder si no hay URL de imagen válida
    final String imageUrl = (product.imagenUrl.isNotEmpty)
        ? product.imagenUrl
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4, // Un poco menos de sombra para que se vea más ligero
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Radio un pelín más ajustado
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. SECCIÓN DE IMAGEN
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey[100]),
            CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      // 1. Widget de error (Reemplaza a errorBuilder)
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                      // 2. Widget de carga con progreso (Reemplaza a loadingBuilder)
                      progressIndicatorBuilder: (context, url, downloadProgress) {
                        return Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              // downloadProgress.progress ya te da el valor entre 0.0 y 1.0
                              value: downloadProgress.progress,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 2. SECCIÓN DE DETALLES (Más compacta)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0), // Padding REDUCIDO
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Título del producto
                    Text(
                      product.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13, // Letra un poco más pequeña (era 14)
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        height: 1.1, // Altura de línea ajustada
                      ),
                    ),

                    // Fila con Precio y Botón
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Precio
                        Text(
                          '\$${product.precio.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15, // Letra ajustada (era 18)
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // Botón pequeño
                        Material(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.nombre} agregado!'),
                                  duration: const Duration(milliseconds: 600),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(5.0), // Padding del botón reducido
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 18, // Icono más pequeño
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}