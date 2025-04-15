// theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default to light mode

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners(); // Notify listeners to rebuild relevant widgets
  }

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, brightness: Brightness.light),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, brightness: Brightness.dark),
    useMaterial3: true,
  );
}
