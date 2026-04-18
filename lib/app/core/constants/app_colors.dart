import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // DARK THEME
  static const Color darkPrimary = Color(0xFF273557);
  static const Color darkNavy = Color(0xFF1B2846);
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color darkCard = Color(0xFF1B2846);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF586279);
  static const Color darkBorder = Color(0x1AFFFFFF);

  static const List<Color> darkGradient = [
    Color(0xFF0D1B2A),
    Color(0xFF1B2846),
    Color(0xFF273557),
  ];
  // LIGHT THEME
  static const Color lightPrimary = Color(0xFF2F80ED);
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1B2846);
  static const Color lightTextSecondary = Color(0xFF586279);
  static const Color lightBorder = Color(0x1A000000);

  static const List<Color> lightGradient = [
    Color(0xFFE8F0FE),
    Color(0xFFF5F7FA),
    Color(0xFFFFFFFF),
  ];

  static const Color greyBlue = Color(0xFF586279);
  static const Color actionBlue = Color(0xFF2F80ED);
  static const Color errorRed = Color(0xFFEF382A);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color warningOrange = Color(0xFFF39C12);
  static const Color white = Color(0xFFFFFFFF);

  static const Color primaryBlue = Color(0xFF273557);
  static const Color lightText = Color(0xFFFFFFFF);
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
