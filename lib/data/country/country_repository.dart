import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Loads and caches the list of countries from the bundled JSON asset.
class CountryRepository {
  CountryRepository._();

  static const String _assetPath = 'assets/data/countries.json';
  static List<String>? _cachedCountries;

  static Future<List<String>> loadCountries() async {
    if (_cachedCountries != null) {
      return _cachedCountries!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    _cachedCountries = decoded.cast<String>();
    return _cachedCountries!;
  }
}


