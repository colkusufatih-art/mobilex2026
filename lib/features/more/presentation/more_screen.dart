import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/icons/m3_icons.dart';
import '../../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      appBar: _buildAppBar(isDark),
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
                        'More',
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

                    // Trading
                    InkWell(
                      onTap: () => context.go('/trading'),
                      child: _buildMenuItem(
                        icon: M3Icons.timeline,
                        title: 'Trading',
                        isDark: isDark,
                      ),
                    ),

                    // Messages
                    InkWell(
                      onTap: () => context.go('/messages'),
                      child: _buildMenuItem(
                        icon: M3Icons.message,
                        title: 'Messages',
                        isDark: isDark,
                      ),
                    ),

                    // Documents
                    InkWell(
                      onTap: () => context.go('/documents'),
                      child: _buildMenuItem(
                        icon: M3Icons.description,
                        title: 'Documents',
                        isDark: isDark,
                      ),
                    ),

                    // Contact & Support
                    InkWell(
                      onTap: () => context.go('/contact-support'),
                      child: _buildMenuItem(
                        icon: M3Icons.call,
                        title: 'Contact & Support',
                        isDark: isDark,
                      ),
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // Settings
                    InkWell(
                      onTap: () => context.go('/settings'),
                      child: _buildMenuItem(
                        icon: M3Icons.tune,
                        title: 'Settings',
                        isDark: isDark,
                      ),
                    ),

                    // My Profile (with subtitle)
                    InkWell(
                      onTap: () => context.go('/profile'),
                      child: _buildMenuItemWithSubtitle(
                        icon: M3Icons.accountCircle,
                        title: 'My Profile',
                        subtitle: 'Reto Haldner | 492734923233',
                        height: 81,
                        isDark: isDark,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const AppBottomNavigation(activeRoute: '/more'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    final iconColor = AppColorSchemes.getTextColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);

    return AppBar(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          M3Icons.arrowBack,
          color: iconColor,
          semanticLabel: 'Zurück',
        ),
        tooltip: 'Zurück', // WCAG 2.2: Tooltip für Accessibility
        onPressed: () => context.go('/home'),
      ),
      actions: [
        Semantics(
          button: true,
          label: 'Abmelden',
          child: TextButton(
            onPressed: () {
              context.go('/login-existing-user');
            },
            child: Text(
              'Logout',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    final iconTextColor = AppColorSchemes.getTextColor(isDark);

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
                color: iconTextColor,
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
                  color: iconTextColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithSubtitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    double height = 84,
  }) {
    final iconTextColor = AppColorSchemes.getTextColor(isDark);

    // WCAG 2.2: Semantics für Menü-Items mit Untertitel
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: Container(
        constraints: BoxConstraints(
          minHeight: height, // WCAG 2.5: Minimum Touch Target
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  icon,
                  size: 24,
                  color: iconTextColor,
                  semanticLabel: title,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: iconTextColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColorSchemes.greysMidGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColorSchemes.getDividerColor(isDark),
      ),
    );
  }
}
