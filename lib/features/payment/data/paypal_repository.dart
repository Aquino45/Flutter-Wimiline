import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/token_service.dart'; // Tu servicio de token

class PaypalRepository {
  // Ajusta la IP si es necesario (10.0.2.2 para emulador Android)
  final String baseUrl = "http://10.0.2.2:8081/api/paypal";

  // 1. CREAR ORDEN
  Future<Map<String, dynamic>> createOrder(double total) async {
    final token = await TokenService.getToken();
    
    final response = await http.post(
      Uri.parse("$baseUrl/create-order"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      // Ajusta este cuerpo según tu DTO 'CreateOrderRequestDTO' de Java
      body: jsonEncode({
        "total": total,
        "currency": "USD", // O "PEN" si tu cuenta PayPal lo soporta
        "method": "paypal",
        "intent": "sale",
        "description": "Compra en Wimiline Market"
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al crear orden PayPal: ${response.body}");
    }
  }

  // 2. CAPTURAR PAGO (Cobrar)
  Future<bool> captureOrder(String orderId) async {
    final token = await TokenService.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/capture-order/$orderId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Asumiendo que tu DTO de respuesta tiene un campo 'status'
      return data['status'] == 'COMPLETED'; 
    } else {
      throw Exception("Error al capturar el pago");
    }
  }
}