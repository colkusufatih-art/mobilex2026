/// Brand-specific font families for white-label templates.
enum BrandFontFamily {
  openSans,
  helveticaNeue,
  roboto,
}

extension BrandFontFamilyX on BrandFontFamily {
  /// Primary font family name (Helvetica Neue is available as a system font on iOS/macOS).
  String get familyName => switch (this) {
        BrandFontFamily.openSans => 'Open Sans',
        BrandFontFamily.helveticaNeue => 'Helvetica Neue',
        BrandFontFamily.roboto => 'Roboto',
      };

  /// Fallback chain when the primary family is unavailable (e.g. on Android).
  List<String> get fallbacks => switch (this) {
        BrandFontFamily.openSans => const ['sans-serif'],
        BrandFontFamily.helveticaNeue => const [
            'Helvetica',
            'Arial',
            'sans-serif',
          ],
        BrandFontFamily.roboto => const ['sans-serif'],
      };
}
