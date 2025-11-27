import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔵 Icono / imagen de la categoría
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: NetworkImage(category.imagenUrl),
                onBackgroundImageError: (_, __) {},
              ),

              const SizedBox(height: 10),

              // 🏷 Nombre
              Text(
                category.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // 📝 Descripción corta
              if (category.descripcion != null &&
                  category.descripcion!.trim().isNotEmpty)
                Text(
                  category.descripcion!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
