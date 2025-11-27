import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';


class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  static WebSocketService get instance => _instance;
  WebSocketService._internal();

  StompClient? client;
  
  // Callback para avisar a quien esté escuchando (la UI)
  Function(String productId, int newStock)? onStockUpdate;

  void connect() {
    // Si ya está conectado, no hacer nada
    if (client != null && client!.connected) return;

    client = StompClient(
      config: StompConfig(
        // URL para emulador Android. Si es dispositivo real usa tu IP local (ej: 192.168.1.X)
        url: 'ws://10.0.2.2:8081/ws-wimi', 
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print("Error WS: $error"),
      ),
    );

    client!.activate();
  }

  void _onConnect(StompFrame frame) {
    print("✅ Conectado al WebSocket");
    
    // Nos suscribimos al canal de stock
    client!.subscribe(
      destination: '/topic/stock',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          final String pId = data['productoId'];
          final int stock = data['nuevoStock'];
          
          print("🔄 Actualización recibida: $pId -> $stock");
          
          // Avisamos a la UI si hay un listener activo
          if (onStockUpdate != null) {
            onStockUpdate!(pId, stock);
          }
        }
      },
    );
  }

  void disconnect() {
    client?.deactivate();
  }
}