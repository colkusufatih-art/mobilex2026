import 'package:flutter/material.dart';
import 'app_brand_config.dart';
import 'app_brand_template.dart';
import 'brand_notifier.dart';

/// Provides [BrandNotifier] to the widget tree.
class BrandScope extends InheritedWidget {
  final BrandNotifier notifier;

  const BrandScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  static BrandNotifier of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BrandScope>();
    assert(scope != null, 'BrandScope not found in context');
    return scope!.notifier;
  }

  static BrandNotifier? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BrandScope>()
        ?.notifier;
  }

  @override
  bool updateShouldNotify(BrandScope oldWidget) =>
      oldWidget.notifier.template != notifier.template;
}

extension BrandContext on BuildContext {
  BrandNotifier get brandNotifier => BrandScope.of(this);
  AppBrandTemplate get appBrand => brandNotifier.template;
  AppBrandConfig get brandConfig => brandNotifier.config;

  String brandLogoAsset({required bool isDark}) {
    final config = brandConfig;
    return isDark ? config.logoDarkAsset : config.logoLightAsset;
  }
}
