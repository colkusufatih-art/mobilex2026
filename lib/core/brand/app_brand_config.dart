import 'package:flutter/material.dart';
import 'app_brand_template.dart';
import 'brand_font_family.dart';

/// Design tokens for a single brand template (colors, logo, typography).
class AppBrandConfig {
  final AppBrandTemplate template;
  final String logoLightAsset;
  final String logoDarkAsset;
  final BrandFontFamily fontFamily;

  // Core brand colors
  final Color activeColor;
  final Color primarySteelblue;
  final Color secondarySteelblue;
  final Color secondarySkyblue;
  final Color amountAccentColor;

  // Backgrounds & surfaces
  final Color lightBackground;
  final Color darkBackground;
  final Color lightCardBackground;
  final Color darkCardBackground;

  // Text
  final Color lightTextPrimary;
  final Color darkTextPrimary;
  final Color lightTextLight;
  final Color greysMidGrey;
  final Color greysDarkGrey;

  // Buttons & UI
  final Color lightButtonBackground;
  final Color lightButtonText;
  final Color lightDividerColor;
  final Color darkDividerColor;
  final Color pinDotActive;
  final Color pinDotInactive;

  // Status
  final Color gainColor;
  final Color lossColor;
  final Color errorColor;

  const AppBrandConfig({
    required this.template,
    required this.logoLightAsset,
    required this.logoDarkAsset,
    required this.fontFamily,
    required this.activeColor,
    required this.primarySteelblue,
    required this.secondarySteelblue,
    required this.secondarySkyblue,
    required this.amountAccentColor,
    required this.lightBackground,
    required this.darkBackground,
    required this.lightCardBackground,
    required this.darkCardBackground,
    required this.lightTextPrimary,
    required this.darkTextPrimary,
    required this.lightTextLight,
    required this.greysMidGrey,
    required this.greysDarkGrey,
    required this.lightButtonBackground,
    required this.lightButtonText,
    required this.lightDividerColor,
    required this.darkDividerColor,
    required this.pinDotActive,
    required this.pinDotInactive,
    required this.gainColor,
    required this.lossColor,
    required this.errorColor,
  });

  ColorScheme lightColorScheme() {
    return ColorScheme.light(
      primary: primarySteelblue,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFF2F2F2),
      onPrimaryContainer: greysDarkGrey,
      secondary: secondarySteelblue,
      onSecondary: Colors.white,
      secondaryContainer: secondarySkyblue,
      onSecondaryContainer: primarySteelblue,
      tertiary: const Color(0xFF990061),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFEF7C00),
      onTertiaryContainer: Colors.white,
      error: errorColor,
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      surface: lightCardBackground,
      onSurface: lightTextPrimary,
      surfaceContainerHighest: lightBackground,
      onSurfaceVariant: greysMidGrey,
      outline: greysMidGrey,
      outlineVariant: lightDividerColor,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: greysDarkGrey,
      onInverseSurface: Colors.white,
      inversePrimary: secondarySkyblue,
      surfaceTint: primarySteelblue,
    );
  }

  ColorScheme darkColorScheme() {
    return ColorScheme.dark(
      primary: secondarySkyblue,
      onPrimary: primarySteelblue,
      primaryContainer: const Color(0xFF00255C),
      onPrimaryContainer: Colors.white,
      secondary: secondarySteelblue,
      onSecondary: Colors.white,
      secondaryContainer: primarySteelblue,
      onSecondaryContainer: secondarySkyblue,
      tertiary: const Color(0xFF990061),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFEF7C00),
      onTertiaryContainer: Colors.white,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: darkBackground,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkCardBackground,
      onSurfaceVariant: greysMidGrey,
      outline: greysMidGrey,
      outlineVariant: const Color(0xFF414744),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Colors.white,
      onInverseSurface: greysDarkGrey,
      inversePrimary: primarySteelblue,
      surfaceTint: secondarySkyblue,
    );
  }

  static AppBrandConfig forTemplate(AppBrandTemplate template) => switch (template) {
        AppBrandTemplate.crealogix => crealogix,
        AppBrandTemplate.volksbankWien => volksbankWien,
        AppBrandTemplate.hypotirol => hypotirol,
      };

  /// Default Crealogix / MobileX design tokens.
  static const crealogix = AppBrandConfig(
    template: AppBrandTemplate.crealogix,
    logoLightAsset: 'assets/img/CLX_Login_215x55-LM.png',
    logoDarkAsset: 'assets/img/CLX_Login_215x55-DM.png',
    fontFamily: BrandFontFamily.openSans,
    activeColor: Color(0xFFFFA814),
    primarySteelblue: Color(0xFF134561),
    secondarySteelblue: Color(0xFF417691),
    secondarySkyblue: Color(0xFF5BC5F2),
    amountAccentColor: Color(0xFFFFA814),
    lightBackground: Color(0xFFF6F5FA),
    darkBackground: Color(0xFF2B2B2B),
    lightCardBackground: Color(0xFFFFFFFF),
    darkCardBackground: Color(0xFF333333),
    lightTextPrimary: Color(0xFF333333),
    darkTextPrimary: Color(0xFFFFFFFF),
    lightTextLight: Color(0xFFDADADA),
    greysMidGrey: Color(0xFF888888),
    greysDarkGrey: Color(0xFF333333),
    lightButtonBackground: Color(0xFF333333),
    lightButtonText: Color(0xFFFFFFFF),
    lightDividerColor: Color(0xFFDADADA),
    darkDividerColor: Color(0xFF333333),
    pinDotActive: Color(0xFFFFA814),
    pinDotInactive: Color(0xFFDADADA),
    gainColor: Color(0xFF34C759),
    lossColor: Color(0xFFC00024),
    errorColor: Color(0xFFBA1A1A),
  );

  /// Volksbank Wien – Figma variables (Volksbank column).
  static const volksbankWien = AppBrandConfig(
    template: AppBrandTemplate.volksbankWien,
    logoLightAsset: 'assets/img/volksbank_wien_logo.png',
    logoDarkAsset: 'assets/img/volksbank_wien_logo.png',
    fontFamily: BrandFontFamily.helveticaNeue,
    activeColor: Color(0xFF135182),
    primarySteelblue: Color(0xFF153B84),
    secondarySteelblue: Color(0xFF135182),
    secondarySkyblue: Color(0xFF135182),
    amountAccentColor: Color(0xFF135182),
    lightBackground: Color(0xFFFAFAFA),
    darkBackground: Color(0xFF153B84),
    lightCardBackground: Color(0xFFFFFFFF),
    darkCardBackground: Color(0xFF153B84),
    lightTextPrimary: Color(0xFF505763),
    darkTextPrimary: Color(0xFFFFFFFF),
    lightTextLight: Color(0xFF888888),
    greysMidGrey: Color(0xFF888888),
    greysDarkGrey: Color(0xFF505763),
    lightButtonBackground: Color(0xFF135182),
    lightButtonText: Color(0xFFFFFFFF),
    lightDividerColor: Color(0xFFD7E3F0),
    darkDividerColor: Color(0xFF135182),
    pinDotActive: Color(0xFF135182),
    pinDotInactive: Color(0xFFD7E3F0),
    gainColor: Color(0xFF88C2B9),
    lossColor: Color(0xFFEF6882),
    errorColor: Color(0xFFC00024),
  );

  /// Hypo Tirol – Figma variables (Hypo Tirol column).
  static const hypotirol = AppBrandConfig(
    template: AppBrandTemplate.hypotirol,
    logoLightAsset: 'assets/img/hypotirol_logo.png',
    logoDarkAsset: 'assets/img/hypotirol_logo.png',
    fontFamily: BrandFontFamily.roboto,
    activeColor: Color(0xFF645A8F),
    primarySteelblue: Color(0xFF22215D),
    secondarySteelblue: Color(0xFF645A8F),
    secondarySkyblue: Color(0xFF49ABA5),
    amountAccentColor: Color(0xFF645A8F),
    lightBackground: Color(0xFFFAFAFA),
    darkBackground: Color(0xFF22215D),
    lightCardBackground: Color(0xFFFFFFFF),
    darkCardBackground: Color(0xFF525763),
    lightTextPrimary: Color(0xFF525763),
    darkTextPrimary: Color(0xFFFFFFFF),
    lightTextLight: Color(0xFF525763),
    greysMidGrey: Color(0xFF888888),
    greysDarkGrey: Color(0xFF525763),
    lightButtonBackground: Color(0xFF22215D),
    lightButtonText: Color(0xFFFFFFFF),
    lightDividerColor: Color(0xFF888888),
    darkDividerColor: Color(0xFF645A8F),
    pinDotActive: Color(0xFF645A8F),
    pinDotInactive: Color(0xFFF0F5FA),
    gainColor: Color(0xFF88C2B9),
    lossColor: Color(0xFFEF6882),
    errorColor: Color(0xFFC00024),
  );
}
