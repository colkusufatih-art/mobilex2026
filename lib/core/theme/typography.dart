import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../brand/app_brand_config.dart';
import '../brand/brand_font_family.dart';

/// Typography based on Figma Text Styles.
///
/// Supports brand-specific font families (Open Sans / Helvetica Neue / Roboto).
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'OpenSans';
  static BrandFontFamily _brandFont = BrandFontFamily.openSans;
  static Color _textColorLight = const Color(0xFF333333);

  static void applyBrand(AppBrandConfig brand) {
    _brandFont = brand.fontFamily;
    _textColorLight = brand.lightTextPrimary;
  }

  static TextStyle _font({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double letterSpacing = 0,
  }) {
    if (_brandFont == BrandFontFamily.openSans) {
      return GoogleFonts.openSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    if (_brandFont == BrandFontFamily.roboto) {
      return GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    return TextStyle(
      fontFamily: _brandFont.familyName,
      fontFamilyFallback: _brandFont.fallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static const double _displayLargeSize = 28;
  static const double _displayMediumSize = 28;
  static const double _displaySmallSize = 22;
  static const double _titleSize = 16;
  static const double _bodyLargeSize = 16;
  static const double _bodySmallSize = 14;
  static const double _labelLargeSize = 16;
  static const double _labelSmallSize = 14;

  static TextTheme textTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : _textColorLight;

    TextStyle style({
      required double fontSize,
      required FontWeight fontWeight,
      double? height,
    }) =>
        _font(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          height: height,
        );

    return TextTheme(
      displayLarge: style(
          fontSize: _displayLargeSize, fontWeight: FontWeight.bold, height: 1.25),
      displayMedium: style(
          fontSize: _displayMediumSize,
          fontWeight: FontWeight.normal,
          height: 1.25),
      displaySmall: style(
          fontSize: _displaySmallSize,
          fontWeight: FontWeight.normal,
          height: 1.4),
      headlineLarge: style(
          fontSize: _displayLargeSize, fontWeight: FontWeight.bold, height: 1.25),
      headlineMedium: style(
          fontSize: _displayMediumSize,
          fontWeight: FontWeight.normal,
          height: 1.25),
      headlineSmall: style(
          fontSize: _displaySmallSize,
          fontWeight: FontWeight.normal,
          height: 1.4),
      titleLarge: style(
          fontSize: _titleSize, fontWeight: FontWeight.bold, height: 1.25),
      titleMedium: style(
          fontSize: _titleSize, fontWeight: FontWeight.bold, height: 1.25),
      titleSmall: style(
          fontSize: _titleSize, fontWeight: FontWeight.normal, height: 1.25),
      bodyLarge: style(
          fontSize: _bodyLargeSize, fontWeight: FontWeight.normal, height: 1.5),
      bodyMedium: style(
          fontSize: _bodyLargeSize, fontWeight: FontWeight.bold, height: 1.5),
      bodySmall: style(
          fontSize: _bodySmallSize, fontWeight: FontWeight.normal, height: 1.5),
      labelLarge: style(
          fontSize: _labelLargeSize, fontWeight: FontWeight.bold, height: 1.25),
      labelMedium: style(
          fontSize: _labelLargeSize, fontWeight: FontWeight.bold, height: 1.25),
      labelSmall: style(
          fontSize: _labelSmallSize, fontWeight: FontWeight.normal, height: 1.5),
    );
  }

  static TextStyle font({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double letterSpacing = 0,
  }) =>
      _font(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle get welcomeTitle => _font(
        fontSize: _displayLargeSize,
        fontWeight: FontWeight.normal,
        color: _textColorLight,
        height: 1.25,
      );

  static TextStyle get welcomeTitleBold => _font(
        fontSize: _displayLargeSize,
        fontWeight: FontWeight.bold,
        color: _textColorLight,
        height: 1.25,
      );

  static TextStyle get pinTitle => _font(
        fontSize: _displaySmallSize,
        fontWeight: FontWeight.normal,
        color: _textColorLight,
        height: 1.4,
      );

  static TextStyle get buttonText => _font(
        fontSize: _titleSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.25,
      );

  static TextStyle get buttonTextSecondary => _font(
        fontSize: _titleSize,
        fontWeight: FontWeight.bold,
        color: _textColorLight,
        height: 1.25,
      );

  static TextStyle get pinForgotten => _font(
        fontSize: _titleSize,
        fontWeight: FontWeight.bold,
        color: _textColorLight,
        height: 1.25,
      );

  static TextStyle get numberButton => _font(
        fontSize: _displayLargeSize,
        fontWeight: FontWeight.normal,
        color: _textColorLight,
        height: 1.25,
      );

  static TextStyle welcomeTitleScaled(BuildContext context) => welcomeTitle;
  static TextStyle welcomeTitleBoldScaled(BuildContext context) => welcomeTitleBold;
  static TextStyle pinTitleScaled(BuildContext context) => pinTitle;
  static TextStyle buttonTextScaled(BuildContext context) => buttonText;
  static TextStyle numberButtonScaled(BuildContext context) => numberButton;
}
