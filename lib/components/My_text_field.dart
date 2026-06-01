import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  const MyTextField({super.key, required this.hintText, required this.controller, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: obscureText,
        
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10)
            ),
            hintText: hintText, hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
        ),
    );
  }
}