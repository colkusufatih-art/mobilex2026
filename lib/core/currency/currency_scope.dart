import 'package:flutter/material.dart';
import 'currency_notifier.dart';

/// InheritedWidget that provides [CurrencyNotifier] to descendants.
/// Use this to access currency preference without circular imports.
class CurrencyScope extends InheritedWidget {
  const CurrencyScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  final CurrencyNotifier notifier;

  static CurrencyScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrencyScope>();
  }

  @override
  bool updateShouldNotify(CurrencyScope oldWidget) =>
      notifier != oldWidget.notifier;
}

/// Extension for currency helpers - use [withAppCurrency] when displaying amounts.
extension CurrencyContextExtension on BuildContext {
  CurrencyNotifier? get currencyNotifier => CurrencyScope.of(this)?.notifier;

  /// Current display currency ('CHF' or 'EUR')
  String get appCurrency => currencyNotifier?.currency ?? 'CHF';

  /// Replace CHF with app currency in text (e.g. 'CHF 50.00' → 'EUR 50.00')
  String withAppCurrency(String text) =>
      currencyNotifier?.withAppCurrency(text) ?? text;
}
