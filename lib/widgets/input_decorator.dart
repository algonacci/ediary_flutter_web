import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String label, String hint) {
  return InputDecoration(
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.green,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: Colors.lightGreenAccent,
        width: 2.0,
      ),
    ),
    labelText: label,
    hintText: hint,
  );
}
