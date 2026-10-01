import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/brand/app_brand_template.dart';
import '../../../core/brand/brand_scope.dart';

/// Splash Screen
///
/// Shows brand logo centered for 1 second then navigates to Login Existing User
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      context.go('/login-existing-user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = context.brandLogoAsset(isDark: isDark);
    final brand = context.appBrand;
    final (logoWidth, logoHeight) = switch (brand) {
      AppBrandTemplate.volksbankWien => (240.0, 64.0),
      AppBrandTemplate.hypotirol => (120.0, 120.0),
      AppBrandTemplate.crealogix => (210.0, 55.0),
    };

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      body: Center(
        child: SizedBox(
          width: logoWidth,
          height: logoHeight,
          child: Image.asset(
            logoAsset,
            fit: BoxFit.contain,
            semanticLabel: context.brandConfig.template.displayName,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColorSchemes.primaryDarkSteelblue,
                child: Center(
                  child: Text(
                    context.brandConfig.template.displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
