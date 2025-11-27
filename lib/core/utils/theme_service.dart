import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {

  static final ThemeService _instance = ThemeService._internal();
  static ThemeService get instance => _instance;

  ThemeService._internal();


  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);


  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  }


  Future<void> toggleTheme(bool isOn) async {
    isDarkMode.value = isOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);
  }
}