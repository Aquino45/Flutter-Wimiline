import 'package:proyecto/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class SessionHelper {

  static Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();


    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login', 
      (route) => false 
    );
    

    final context = navigatorKey.currentState?.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tu sesión ha expirado. Ingresa nuevamente."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}