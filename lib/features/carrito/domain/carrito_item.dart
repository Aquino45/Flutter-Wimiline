import '../../productos/data/product_model.dart';

class CarritoItem {
  final Product product;
  int quantity;

  CarritoItem({
    required this.product,
    this.quantity = 1,
  });

  // Calcula el subtotal de este item (Precio x Cantidad)
  double get subtotal => product.precio * quantity;
}