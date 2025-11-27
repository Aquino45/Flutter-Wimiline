import 'package:flutter/material.dart';
import 'package:proyecto/core/services/websocket_service.dart';
import 'package:proyecto/core/utils/theme_service.dart'; // 👈 Importante
import 'features/splash/presentation/splash_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'core/widgets/main_nav_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializamos el servicio de tema para cargar la preferencia guardada
  await ThemeService.instance.init();
  WebSocketService.instance.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 ESTO ES LO IMPORTANTE: Escuchamos el cambio de tema globalmente
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.instance.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'Wimiline',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          
          // 🌞 TEMA CLARO
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Fondo gris claro
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            cardColor: Colors.white,
            useMaterial3: true,
          ),

          // 🌑 TEMA OSCURO
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212), // Fondo oscuro real
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark, // Importante para que genere colores oscuros
            ),
            cardColor: const Color(0xFF1E1E1E), // Tarjetas gris oscuro
            useMaterial3: true,
          ),

          // Aquí se decide qué tema usar
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/main': (context) => const MainNavPage(),
          },
          home: const SplashPage(),
        );
      },
    );
  }
}