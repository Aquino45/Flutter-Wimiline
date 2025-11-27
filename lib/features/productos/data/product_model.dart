class Product {
  final String id; // 👈 NUEVO CAMPO IMPORTANTE
  final String idCategoria;
  final String nombre;
  final String? descripcion;
  final String? detalles;
  final double precio;
  final int stock;
  final String imagenUrl;
  final bool activo;

  Product({
    required this.id, // 👈 Agrégalo al constructor
    required this.idCategoria,
    required this.nombre,
    this.descripcion,
    this.detalles,
    required this.precio,
    required this.stock,
    required this.imagenUrl,
    required this.activo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // 👈 Mapea el UUID que viene del backend
      id: json['productoId'] ?? '', 
      
      idCategoria: json['categoriaId'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      detalles: json['detalles'],
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      imagenUrl: json['imagenUrl'] ?? '',
      activo: json['activo'] ?? false,
    );
  }
}