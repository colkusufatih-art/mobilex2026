import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/brand/brand_notifier.dart';
import '../../../../core/brand/brand_scope.dart';
import '../../../../core/icons/m3_icons.dart';
import '../../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../../app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeNotifier? _themeNotifier;
  BrandNotifier? _brandNotifier;
  bool _dependenciesReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _dependenciesReady = true;

    _themeNotifier = context.themeNotifier;
    _brandNotifier = context.brandNotifier;
    _themeNotifier?.addListener(_onNotifierChanged);
    _brandNotifier?.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    _themeNotifier?.removeListener(_onNotifierChanged);
    _brandNotifier?.removeListener(_onNotifierChanged);
    super.dispose();
  }

  void _onNotifierChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final darkModeEnabled = _themeNotifier?.isDarkMode ?? false;
    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.md,
                        bottom: AppSpacing.md,
                      ),
                      child: Text(
                        'Settings',
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: isDark
                              ? AppColorSchemes.darkTextPrimary
                              : AppColorSchemes.greysDarkGrey,
                          height: 1.25,
                        ),
                      ),
                    ),

                    // Alias
                    _buildMenuItem(
                      icon: M3Icons.textFormat,
                      title: 'Alias',
                    ),

                    // Payments
                    _buildMenuItem(
                      icon: M3Icons.payment,
                      title: 'Payments',
                    ),

                    // Trading
                    _buildMenuItem(
                      icon: M3Icons.timeline,
                      title: 'Trading',
                    ),

                    // Device properties
                    InkWell(
                      onTap: () => context.go('/device-properties'),
                      child: _buildMenuItem(
                        icon: M3Icons.permDeviceInformation,
                        title: 'Device properties',
                      ),
                    ),

                    // Dark Mode (with Switch)
                    _buildMenuItemWithSwitch(
                      icon: M3Icons.settingsBrightness,
                      title: 'Dark Mode',
                      value: darkModeEnabled,
                      onChanged: (value) async {
                        if (value) {
                          await _themeNotifier?.setThemeMode(ThemeMode.dark);
                        } else {
                          await _themeNotifier?.setThemeMode(ThemeMode.light);
                        }
                      },
                    ),

                    // Volksbank Wien template
                    _buildMenuItemWithSwitch(
                      icon: M3Icons.accountBalance,
                      title: 'Volksbank Wien',
                      value: _brandNotifier?.isVolksbankWien ?? false,
                      onChanged: (value) async {
                        await _brandNotifier?.setVolksbankWien(value);
                      },
                    ),

                    // Hypotirol template (placeholder)
                    _buildMenuItemWithSwitch(
                      icon: M3Icons.accountBalance,
                      title: 'Hypotirol',
                      value: _brandNotifier?.isHypotirol ?? false,
                      onChanged: (value) async {
                        await _brandNotifier?.setHypotirol(value);
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const AppBottomNavigation(activeRoute: '/settings'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          M3Icons.arrowBack,
          color: isDark
              ? AppColorSchemes.darkTextPrimary
              : AppColorSchemes.greysDarkGrey,
          semanticLabel: 'Zurück',
        ),
        tooltip: 'Zurück', // WCAG 2.2: Tooltip für Accessibility
        onPressed: () => context.go('/more'),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColorSchemes.darkTextPrimary
        : AppColorSchemes.greysDarkGrey;

    // WCAG 2.2: Semantics für Menü-Items
    return Semantics(
      button: true,
      label: title,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 64, // WCAG 2.5: Minimum Touch Target
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                icon,
                size: 24,
                color: textColor,
                semanticLabel: title,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColorSchemes.darkTextPrimary
        : AppColorSchemes.greysDarkGrey;

    // WCAG 2.2: Semantics für Switch-Menü-Items
    return Semantics(
      toggled: value,
      label: '$title, ${value ? "aktiviert" : "deaktiviert"}',
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 64, // WCAG 2.5: Minimum Touch Target
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                icon,
                size: 24,
                color: textColor,
                semanticLabel: title,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),

            // Switch - excludeSemantics da parent Semantics
            ExcludeSemantics(
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColorSchemes.primaryDarkYellow,
                activeThumbColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
