import 'package:flutter/material.dart';
import 'core/theme/color_schemes.dart';
import 'core/theme/typography.dart';
import 'core/theme/theme_notifier.dart';
import 'core/account/account_notifier.dart';
import 'core/currency/currency_notifier.dart';
import 'core/currency/currency_scope.dart';
import 'core/brand/brand_notifier.dart';
import 'core/brand/app_brand_template.dart';
import 'core/brand/brand_scope.dart';
import 'routing/app_router.dart';

/// Main App Widget
///
/// Configures MaterialApp with Theme and Router
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ThemeNotifier _themeNotifier = ThemeNotifier();
  final BrandNotifier _brandNotifier = BrandNotifier();
  final AccountNotifier _accountNotifier = AccountNotifier();
  final CurrencyNotifier _currencyNotifier = CurrencyNotifier();

  @override
  void dispose() {
    _themeNotifier.dispose();
    _brandNotifier.dispose();
    _accountNotifier.dispose();
    super.dispose();
  }

  ThemeData _buildTheme({required bool isDark}) {
    final colorScheme = isDark ? AppColorSchemes.dark : AppColorSchemes.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(colorScheme),
      scaffoldBackgroundColor:
          isDark ? AppColorSchemes.darkBackground : AppColorSchemes.lightBackground,
      iconTheme: const IconThemeData(weight: 600),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorSchemes.lightButtonBackground,
          foregroundColor: AppColorSchemes.lightButtonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorSchemes.primaryDarkYellow;
          }
          return null;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _themeNotifier,
        _brandNotifier,
        _accountNotifier,
        _currencyNotifier,
      ]),
      builder: (context, child) {
        return BrandScope(
          notifier: _brandNotifier,
          child: CurrencyScope(
            notifier: _currencyNotifier,
            child: MaterialApp.router(
              title: switch (_brandNotifier.template) {
                AppBrandTemplate.volksbankWien => 'Volksbank Wien',
                AppBrandTemplate.hypotirol => 'Hypo Tirol',
                AppBrandTemplate.crealogix => 'Crealogix Mobile Banking',
              },
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(isDark: false),
              darkTheme: _buildTheme(isDark: true),
              themeMode: _themeNotifier.themeMode,
              routerConfig: appRouter,
            ),
          ),
        );
      },
    );
  }

  static _AppState? _appStateOf(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  static AccountNotifier? getAccountNotifier(BuildContext context) {
    return _appStateOf(context)?._accountNotifier;
  }
}

extension AppContextExtension on BuildContext {
  ThemeNotifier? get themeNotifier =>
      _AppState._appStateOf(this)?._themeNotifier;

  AccountNotifier? get accountNotifier => _AppState.getAccountNotifier(this);
}
