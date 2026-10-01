import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Currency Notifier for managing CHF/EUR display preference
///
/// Persists currency preference and notifies listeners of changes.
/// When EUR is enabled, all CHF labels across the app display as EUR.
class CurrencyNotifier extends ChangeNotifier {
  static const String _useEurKey = 'currency_use_eur';

  bool _useEur = false;
  bool _userHasChanged = false;

  /// Whether EUR mode is enabled (default: false = CHF)
  bool get useEur => _useEur;

  /// Current display currency: 'EUR' when useEur is true, otherwise 'CHF'
  String get currency => _useEur ? 'EUR' : 'CHF';

  CurrencyNotifier() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_userHasChanged) return;
      _useEur = prefs.getBool(_useEurKey) ?? false;
      notifyListeners();
    } catch (_) {
      if (!_userHasChanged) _useEur = false;
    }
  }

  /// Set EUR mode. When true, app displays EUR instead of CHF.
  Future<void> setUseEur(bool value) async {
    if (_useEur == value) return;

    _userHasChanged = true;
    _useEur = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useEurKey, value);
    } catch (_) {
      // In-memory change already applied
    }
  }

  /// Replace CHF with current currency in display strings
  String withAppCurrency(String text) {
    return text.replaceAll('CHF', currency);
  }
}
