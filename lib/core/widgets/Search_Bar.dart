import 'package:flutter/material.dart';

class SearchBar1 extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBar1({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Detectamos el modo oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Definimos los colores según el modo
    // Gris moderno (Charcoal) para dark mode, Blanco para light mode
    final backgroundColor = isDarkMode ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey;
    final borderColor = isDarkMode ? Colors.transparent : Colors.grey.shade300;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: backgroundColor, // ✅ Fondo adaptable
          boxShadow: [
            BoxShadow(
              // Sombra más sutil en modo oscuro
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 10.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(color: textColor), // ✅ El texto que escribes se ve blanco en modo oscuro
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: hintColor), // ✅ Hint gris suave
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.deepPurple,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1), // ✅ Borde solo en modo claro
              borderRadius: BorderRadius.circular(25.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ),
    );
  }
}