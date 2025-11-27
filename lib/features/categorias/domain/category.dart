class Category {
  final String id;
  final String nombre;
  final String? descripcion;
  final bool activa;
  final String imagenUrl;

  Category({
    required this.id, 
    required this.nombre,
    this.descripcion,
    required this.activa,
    required this.imagenUrl,
  });
}
