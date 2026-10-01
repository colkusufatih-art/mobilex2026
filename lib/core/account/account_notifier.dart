import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Account Notifier for managing account aliases
///
/// Persists account aliases and notifies listeners of changes
class AccountNotifier extends ChangeNotifier {
  static const String _aliasesKey = 'account_aliases';

  final Map<String, String> _aliases = {};

  /// Get the alias for an account, or return the original name if no alias exists
  String getAlias(String accountName) {
    return _aliases[accountName] ?? accountName;
  }

  /// Check if an account has a custom alias
  bool hasAlias(String accountName) {
    return _aliases.containsKey(accountName);
  }

  /// Set an alias for an account
  Future<void> setAlias(String accountName, String alias) async {
    if (_aliases[accountName] == alias) return;

    if (alias == accountName || alias.isEmpty) {
      // Remove alias if it's the same as the original name or empty
      _aliases.remove(accountName);
    } else {
      _aliases[accountName] = alias;
    }

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_aliasesKey, jsonEncode(_aliases));
    } catch (e) {
      // If saving fails, continue with alias change in memory
    }
  }

  /// Remove an alias for an account
  Future<void> removeAlias(String accountName) async {
    if (!_aliases.containsKey(accountName)) return;

    _aliases.remove(accountName);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_aliasesKey, jsonEncode(_aliases));
    } catch (e) {
      // If saving fails, continue with alias removal in memory
    }
  }

  /// Load aliases from SharedPreferences
  Future<void> _loadAliases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAliases = prefs.getString(_aliasesKey);

      if (savedAliases != null) {
        final Map<String, dynamic> decoded = jsonDecode(savedAliases);
        _aliases.clear();
        _aliases.addAll(Map<String, String>.from(decoded));
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, start with empty aliases
      _aliases.clear();
    }
  }

  AccountNotifier() {
    _loadAliases();
  }
}


