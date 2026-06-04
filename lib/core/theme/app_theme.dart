import 'package:flutter/material.dart';

class AppTheme {
  static const _navy = Color(0xFF09111F);
  static const _panel = Color(0xFF121C2A);
  static const _cyan = Color(0xFF38D5F5);
  static const _amber = Color(0xFFF6B44B);
  static const _green = Color(0xFF4CD884);

  static ThemeData dark() {
    return _base(
      brightness: Brightness.dark,
      scaffold: _navy,
      surface: _panel,
      onSurface: Colors.white,
    );
  }

  static ThemeData light() {
    return _base(
      brightness: Brightness.light,
      scaffold: const Color(0xFFF3F7FA),
      surface: Colors.white,
      onSurface: const Color(0xFF101826),
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color onSurface,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _cyan,
      brightness: brightness,
      primary: _cyan,
      secondary: _amber,
      tertiary: _green,
      surface: surface,
      onSurface: onSurface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffold,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _cyan,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade600,
          disabledForegroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? const Color(0xFF172335)
            : const Color(0xFFEAF0F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
