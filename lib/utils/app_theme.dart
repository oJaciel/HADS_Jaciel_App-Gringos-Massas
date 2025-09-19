import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF006900),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF8fd894),
    onPrimaryContainer: Colors.black,
    secondary: const Color(0xFF8fd894),
    onSecondary: Colors.black,
    secondaryContainer: const Color(0xFF006900),
    onSecondaryContainer: Colors.white,
    error: const Color(0xFF980000),
    onError: Colors.white,
    errorContainer: const Color(0xFFea9898),
    onErrorContainer: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF006900),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF006900),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF006900),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF8fd894).withOpacity(0.2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
