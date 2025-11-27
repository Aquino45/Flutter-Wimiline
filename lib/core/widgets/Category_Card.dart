import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/features/categorias/domain/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Detectamos el modo oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Colores de texto dinámicos
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final arrowColor = isDarkMode ? Colors.grey[500] : Colors.deepPurple.shade200;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        // ✅ Fondo dinámico: Blanco en día, Gris oscuro en noche
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // Sombra más sutil en modo oscuro
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 🖼 1. Imagen de la Categoría
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    // Fondo suave detrás de la imagen (útil si es PNG transparente)
                    color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: category.imagenUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.category_outlined,
                        // Icono sutil en caso de error
                        color: isDarkMode ? Colors.white24 : Colors.deepPurple.shade300,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // 📝 2. Información (Título y Descripción)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.nombre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: titleColor, // ✅ Color adaptable
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (category.descripcion != null &&
                          category.descripcion!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.descripcion!,
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor, // ✅ Color adaptable
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // ➡️ 3. Icono de Flecha
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: arrowColor, // ✅ Color adaptable
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}