import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
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
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboard,
      

      style: const TextStyle(
        fontSize: 16, 
        color: Colors.black, 
        fontWeight: FontWeight.w500 
      ), 
      
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.deepPurple) : null,
        labelText: widget.label,
        

        labelStyle: TextStyle(
          fontSize: 15, 
          color: Colors.grey.shade800 
        ),
        
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
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.deepPurple,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}