

import 'package:proyecto/features/categorias/domain/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,    
    required super.nombre,
    super.descripcion,
    required super.activa,
    required super.imagenUrl,
  });

factory CategoryModel.fromJson(Map<String, dynamic> json) {
  return CategoryModel(
    // ✅ CORRECCIÓN: Usar el nombre exacto del DTO de Java
    id: json['categoriaId'] ?? '', 
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'],
    activa: json['activa'] ?? false,
    imagenUrl: json['imagenUrl'] ?? '',
  );
}
}
