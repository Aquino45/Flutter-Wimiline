import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final IconData? icon;
  final TextInputType keyboard;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.keyboard = TextInputType.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        labelText: label,
        labelStyle: const TextStyle(fontSize: 15),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}
