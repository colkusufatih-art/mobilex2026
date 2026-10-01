import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Notifier for managing app theme mode
/// 
/// Persists theme preference and notifies listeners of changes
class ThemeNotifier extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }

  ThemeNotifier() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);
      
      if (savedMode != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, use system default
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } catch (e) {
      // If saving fails, continue with theme change in memory
    }
  }

  Future<void> toggleDarkMode() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}

