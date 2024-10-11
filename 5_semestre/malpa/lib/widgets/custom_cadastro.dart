// custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    String? errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Color.fromARGB(255, 255, 255, 255),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          floatingLabelBehavior:
              FloatingLabelBehavior.never, // Mantém o rótulo dentro do campo
          contentPadding: EdgeInsets.symmetric(
              vertical: 15.0, horizontal: 10.0), // Ajusta o padding interno
        ),
      ),
    );
  }
}
