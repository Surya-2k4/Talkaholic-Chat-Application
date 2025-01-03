import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme.light(
  primary: Colors.blueAccent,
  onPrimary: Colors.white,
  secondary: Colors.cyan,
  onSecondary: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
);

final ColorScheme darkColorScheme = ColorScheme.dark(
  primary: Colors.deepPurpleAccent,
  onPrimary: Colors.white,
  secondary: Colors.orangeAccent,
  onSecondary: Colors.white,
  background: Colors.black,
  onBackground: Colors.white,
  surface: Colors.black,
  onSurface: Colors.white,
);

final ColorScheme loveColorScheme = ColorScheme.light(
  primary: Colors.pinkAccent,
  onPrimary: Colors.white,
  secondary: Colors.deepOrangeAccent,
  onSecondary: Colors.white,
  background: Colors.pink[50]!, // Light background for love theme
  onBackground: Colors.black,
  surface: Colors.pink[100]!, // Soft surface color
  onSurface: Colors.black,
);

final ColorScheme funnyColorScheme = ColorScheme.light(
  primary: const Color.fromARGB(255, 255, 130, 13),
  onPrimary: Colors.black,
  secondary: Colors.purpleAccent,
  onSecondary: Colors.white,
  background: Colors.yellow[50]!,
  
  onBackground: Colors.black,
  surface: Colors.yellow[100]!,
  onSurface: Colors.black,
);

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode;
  ColorScheme _lightScheme;
  ColorScheme _darkScheme;
  ColorScheme _loveScheme;
  ColorScheme _funnyScheme;

  var theme;

  // Set default theme as Love
  ThemeProvider()
      : _themeMode = ThemeMode.light,  // Set to light theme by default
        _lightScheme = loveColorScheme,
        _darkScheme = loveColorScheme, // Love theme applies to both light and dark
        _loveScheme = loveColorScheme,
        _funnyScheme = funnyColorScheme;

  ThemeMode get themeMode => _themeMode;

  // Set Light Theme
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    _lightScheme = lightColorScheme;
    _darkScheme = darkColorScheme;
    notifyListeners();
  }

  // Set Dark Theme
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    _lightScheme = lightColorScheme;
    _darkScheme = darkColorScheme;
    notifyListeners();
  }

  // Set Love Theme
  void setLoveTheme() {
    _lightScheme = loveColorScheme;
    _darkScheme = loveColorScheme;
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  // Set Funny Theme
  void setFunnyTheme() {
    _lightScheme = funnyColorScheme;
    _darkScheme = funnyColorScheme;
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  // Getters for color schemes
  ColorScheme get lightScheme => _lightScheme;
  ColorScheme get darkScheme => _darkScheme;
  ColorScheme get loveScheme => _loveScheme;
  ColorScheme get funnyScheme => _funnyScheme;
}
