import 'package:flutter/material.dart';

/// Border radius tokens from Figma design
class AppRadius {
  AppRadius._();

  // Standard radius values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 20.0;
  static const double xl = 100.0; // For circular buttons/dots

  // Figma-specific radius values
  static const double buttonRadius = 8.0;
  static const double bottomSheetHandleRadius = 4.0;
  static const double iconButtonRadius = 8.0;
  static const double pinDotRadius = 100.0; // Full circle
  static const double timeIndicatorRadius = 20.0;

  // BorderRadius presets
  static const BorderRadius button = BorderRadius.all(Radius.circular(buttonRadius));
  static const BorderRadius bottomSheetHandle = BorderRadius.all(Radius.circular(bottomSheetHandleRadius));
  static const BorderRadius iconButton = BorderRadius.all(Radius.circular(iconButtonRadius));
  static const BorderRadius pinDot = BorderRadius.all(Radius.circular(pinDotRadius));
  static const BorderRadius timeIndicator = BorderRadius.all(Radius.circular(timeIndicatorRadius));
}

