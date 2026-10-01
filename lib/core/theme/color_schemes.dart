import 'package:flutter/material.dart';
import '../brand/app_brand_config.dart';

/// Figma Design Token Colors mapped to Material 3 ColorScheme
///
/// Supports multiple brand templates via [applyBrand].
class AppColorSchemes {
  AppColorSchemes._();

  static AppBrandConfig _brand = AppBrandConfig.crealogix;

  static void applyBrand(AppBrandConfig brand) {
    _brand = brand;
  }

  static AppBrandConfig get currentBrand => _brand;

  // Brand-aware tokens (used across the app)
  static Color get primaryDarkYellow => _brand.activeColor;
  static Color get primaryDarkSteelblue => _brand.primarySteelblue;
  static Color get secondarySteelblue => _brand.secondarySteelblue;
  static Color get secondarySkyblue => _brand.secondarySkyblue;
  static Color get amountAccentColor => _brand.amountAccentColor;

  static Color get lightBackground => _brand.lightBackground;
  static Color get darkBackground => _brand.darkBackground;
  static Color get lightButtonBackground => _brand.lightButtonBackground;
  static Color get lightButtonText => _brand.lightButtonText;
  static Color get lightTextPrimary => _brand.lightTextPrimary;
  static Color get darkTextPrimary => _brand.darkTextPrimary;
  static Color get lightTextLight => _brand.lightTextLight;
  static Color get darkTextLight => const Color(0xFF333333);
  static Color get lightCardBackground => _brand.lightCardBackground;
  static Color get darkCardBackground => _brand.darkCardBackground;
  static Color get lightDividerColor => _brand.lightDividerColor;
  static Color get darkDividerColor => _brand.darkDividerColor;
  static Color get pinDotActive => _brand.pinDotActive;
  static Color get pinDotInactive => _brand.pinDotInactive;
  static Color get gainColor => _brand.gainColor;
  static Color get lossColor => _brand.lossColor;

  // Shared tokens (unchanged across brands)
  static const Color primaryLightGrey = Color(0xFFF2F2F2);
  static const Color secondaryDarkPink = Color(0xFF990061);
  static const Color secondaryOrange = Color(0xFFEF7C00);
  static const Color secondaryPrussianBlue = Color(0xFF00255C);
  static Color get greysDarkGrey => _brand.greysDarkGrey;
  static const Color greysMidGrey = Color(0xFF888888);
  static const Color greysLightGrey = Color(0xFFDADADA);
  static const Color darkenLayerColor = Color(0xFF6D6D6D);
  static const Color bottomSheetHandle = Color(0xFFDADADA);
  static const Color greysWhite = Color(0xFFFFFFFF);
  static const Color greysBlack = Color(0xFF000000);

  static Color getTextColor(bool isDark) {
    return isDark ? darkTextPrimary : lightTextPrimary;
  }

  static Color getTextLightColor(bool isDark) {
    return isDark ? darkTextLight : lightTextLight;
  }

  static Color getCardBackgroundColor(bool isDark) {
    return isDark ? darkCardBackground : lightCardBackground;
  }

  static Color getDividerColor(bool isDark) {
    return isDark ? darkDividerColor : lightDividerColor;
  }

  static ColorScheme get light => _brand.lightColorScheme();
  static ColorScheme get dark => _brand.darkColorScheme();
}
