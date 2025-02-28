import 'package:flutter/material.dart';

class AppThemes {
  static const List<Color> primaryColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.red,
  ];

  static String getThemeName(int index) {
    switch (index) {
      case 0:
        return 'Purple';
      case 1:
        return 'Blue';
      case 2:
        return 'Teal';
      case 3:
        return 'Orange';
      case 4:
        return 'Pink';
      case 5:
        return 'Indigo';
      case 6:
        return 'Red';
      default:
        return 'Purple';
    }
  }

  static ThemeData getLightTheme(int colorIndex) {
    final Color primaryColor = primaryColors[colorIndex % primaryColors.length];
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        elevation: 2,
        shadowColor: Colors.black26,
        backgroundColor: primaryColor.withOpacity(0.1),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  static ThemeData getDarkTheme(int colorIndex) {
    final Color primaryColor = primaryColors[colorIndex % primaryColors.length];
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 2,
        shadowColor: Colors.black54,
        backgroundColor: Colors.grey.shade900,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade900,
      ),
    );
  }
}
