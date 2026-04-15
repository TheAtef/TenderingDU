import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF273557);

  static const Color darkNavy = Color(0xFF1B2846);

  static const Color greyBlue = Color(0xFF586279);

  static const Color actionBlue = Color(0xFF2F80ED);

  static const Color errorRed = Color(0xFFEF382A);
  static const Color lightText = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Gradient accentGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 241, 36, 0),
      Color.fromARGB(255, 83, 152, 243),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
