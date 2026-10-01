import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/color_schemes.dart';
import '../theme/typography.dart';
import 'app_brand_config.dart';
import 'app_brand_template.dart';

/// Manages the active white-label brand template.
class BrandNotifier extends ChangeNotifier {
  static const String _brandKey = 'app_brand_template';

  AppBrandTemplate _template = AppBrandTemplate.crealogix;

  AppBrandTemplate get template => _template;
  AppBrandConfig get config => AppBrandConfig.forTemplate(_template);

  bool get isVolksbankWien => _template == AppBrandTemplate.volksbankWien;
  bool get isHypotirol => _template == AppBrandTemplate.hypotirol;
  bool get isCrealogix => _template == AppBrandTemplate.crealogix;

  BrandNotifier() {
    _loadBrand();
  }

  Future<void> _loadBrand() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_brandKey);
      if (saved != null) {
        final template = AppBrandTemplate.values.firstWhere(
          (t) => t.name == saved,
          orElse: () => AppBrandTemplate.crealogix,
        );
        _applyTemplate(template, notify: false);
        notifyListeners();
      }
    } catch (_) {
      _applyTemplate(AppBrandTemplate.crealogix, notify: false);
    }
  }

  void _applyTemplate(AppBrandTemplate template, {bool notify = true}) {
    _template = template;
    final config = AppBrandConfig.forTemplate(template);
    AppColorSchemes.applyBrand(config);
    AppTypography.applyBrand(config);
    if (notify) notifyListeners();
  }

  Future<void> setTemplate(AppBrandTemplate template) async {
    if (_template == template) return;
    _applyTemplate(template);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_brandKey, template.name);
    } catch (_) {}
  }

  Future<void> setVolksbankWien(bool enabled) async {
    if (enabled) {
      await setTemplate(AppBrandTemplate.volksbankWien);
    } else if (_template == AppBrandTemplate.volksbankWien) {
      await setTemplate(AppBrandTemplate.crealogix);
    }
  }

  Future<void> setHypotirol(bool enabled) async {
    if (enabled) {
      await setTemplate(AppBrandTemplate.hypotirol);
    } else if (_template == AppBrandTemplate.hypotirol) {
      await setTemplate(AppBrandTemplate.crealogix);
    }
  }
}
