/// Available white-label brand templates for the app.
enum AppBrandTemplate {
  crealogix,
  volksbankWien,
  hypotirol,
}

extension AppBrandTemplateX on AppBrandTemplate {
  String get displayName => switch (this) {
        AppBrandTemplate.crealogix => 'Crealogix',
        AppBrandTemplate.volksbankWien => 'Volksbank Wien',
        AppBrandTemplate.hypotirol => 'Hypo Tirol',
      };
}
