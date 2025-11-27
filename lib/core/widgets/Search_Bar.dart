import 'package:flutter/material.dart';

class SearchBar1 extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBar1({Key? key, required this.controller, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), // Bordes redondeados más suaves
          color: Colors.white, // Fondo blanco
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(75, 73, 73, 0.259), // Usamos RGBA para control de opacidad
              blurRadius: 10.0, // Sombra difusa
              offset: const Offset(0, 5), // Dirección de la sombra
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.grey), // Estilo del texto del hint
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.deepPurple, // Icono con color morado
            ),
            border: InputBorder.none, // Sin borde adicional
            focusedBorder: InputBorder.none, // Sin borde cuando se enfoca
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1), // Borde sutil cuando no está enfocado
              borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Espaciado dentro del TextField
          ),
        ),
      ),
    );
  }
}
