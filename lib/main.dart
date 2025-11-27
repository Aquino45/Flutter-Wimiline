import 'package:flutter/material.dart';
import 'features/splash/presentation/splash_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'core/widgets/main_nav_page.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      debugShowCheckedModeBanner: false,

      navigatorKey: navigatorKey,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => const MainNavPage(),  
      },

      home: const SplashPage(),
    );
  }
}
