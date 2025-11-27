import 'package:flutter/foundation.dart';
import 'package:proyecto/core/utils/token_service.dart';
import '../../productos/data/product_model.dart';
import '../domain/carrito_item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CarritoService {

  static final CarritoService _instance = CarritoService._internal();
  static CarritoService get instance => _instance;
  CarritoService._internal();


  final ValueNotifier<List<CarritoItem>> itemsNotifier = ValueNotifier([]);


  List<CarritoItem> get items => itemsNotifier.value;

  double get totalAmount => items.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  //////AGREGAR PRODUCTO
  void addToCart(Product product) {
    final currentItems = List<CarritoItem>.from(items);
    
    final index = currentItems.indexWhere((item) => item.product.nombre == product.nombre);

    if (index >= 0) {
      currentItems[index].quantity++;
    } else {

      currentItems.add(CarritoItem(product: product));
    }
    itemsNotifier.value = currentItems;
  }

  ////// DISMINUIR CANTIDAD
  void removeOrDecrement(Product product) {
    final currentItems = List<CarritoItem>.from(items);
    final index = currentItems.indexWhere((item) => item.product.nombre == product.nombre);

    if (index >= 0) {
      if (currentItems[index].quantity > 1) {
        currentItems[index].quantity--;
      } else {
        currentItems.removeAt(index);
      }
      itemsNotifier.value = currentItems;
    }
  }

  //// ELIMINAR ITEM COMPLETO
  void removeItem(Product product) {
    final currentItems = List<CarritoItem>.from(items);
    currentItems.removeWhere((item) => item.product.nombre == product.nombre);
    itemsNotifier.value = currentItems;
  }

  /////LIMPIAR TODO
  void clearCart() {
    itemsNotifier.value = [];
  }

  // ... métodos anteriores (addToCart, removeItem, etc) ...

  // 🚀 NUEVO: ENVIAR PEDIDO AL BACKEND
  Future<bool> realizarPedido() async {
    if (items.isEmpty) return false;

    const String url = "http://10.0.2.2:8081/api/pedidos/checkout";

    try {
      // 1. Obtener el token guardado
      final token = await TokenService.getToken();
      if (token == null) throw Exception("No hay sesión activa");

      // 2. Construir el JSON exactamente como lo espera el DTO de Java
      // PedidoRequestDTO { items: [ { productoId: "...", cantidad: 1 } ] }
      final Map<String, dynamic> pedidoJson = {
        "items": items.map((item) => {
          "productoId": item.product.id, // El UUID del producto
          "cantidad": item.quantity
        }).toList(),
        // "direccionId": "..." // (Opcional si implementas direcciones)
      };

      // 3. Enviar petición POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(pedidoJson),
      );

      // 4. Verificar respuesta
      if (response.statusCode == 200) {
        // ¡Éxito! Limpiamos el carrito local
        clearCart();
        return true;
      } else {
        // Error del backend (ej: stock insuficiente)
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Error al procesar el pedido");
      }
    } catch (e) {
      print("Error checkout: $e");
      rethrow; // Re-lanzamos el error para que la UI lo muestre
    }
  }
}
