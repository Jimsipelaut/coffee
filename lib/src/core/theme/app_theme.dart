// lib/src/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.brown,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0C0F14),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
    ).copyWith(
      secondary: Colors.orange,
    ),
  );
}