import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';

/// App Bottom Navigation Component
///
/// Reusable bottom navigation bar with consistent styling across all screens
class AppBottomNavigation extends StatelessWidget {
  final String activeRoute;

  const AppBottomNavigation({
    super.key,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 87,
      decoration: BoxDecoration(
        color: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        border: Border(
          top: BorderSide(
            color: AppColorSchemes.getDividerColor(isDark),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.xs, // 8px bottom padding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: M3Icons.dashboard,
              label: 'Home',
              route: '/home',
              isActive: activeRoute == '/home',
            ),
            _buildNavItem(
              context: context,
              icon: M3Icons.corporateFare,
              label: 'Assets',
              route: '/assets',
              isActive: activeRoute == '/assets',
            ),
            _buildNavItem(
              context: context,
              icon: M3Icons.qrCodeScanner,
              label: 'Payments',
              route: '/payments',
              isActive: activeRoute == '/payments',
            ),
            _buildNavItem(
              context: context,
              icon: M3Icons.moreHoriz,
              label: 'More',
              route: '/more',
              isActive: activeRoute == '/more',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark
        ? AppColorSchemes.getTextColor(isDark)
        : AppColorSchemes.greysDarkGrey;

    // WCAG 2.2: Semantics für Navigation-Items
    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        label: '$label Tab${isActive ? ", ausgewählt" : ""}',
        child: InkWell(
          onTap: () {
            if (!isActive) {
              context.go(route);
            }
          },
          child: Container(
            height: 48, // WCAG 2.5: Minimum Touch Target 48dp
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme(
                  data: const IconThemeData(
                    // Preserve default/regular weight for bottom navigation icons
                    weight: 400,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isActive
                        ? AppColorSchemes.primaryDarkYellow
                        : inactiveColor,
                    semanticLabel: label,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.33, // 16px / 12px
                    color: isActive
                        ? AppColorSchemes.primaryDarkYellow
                        : inactiveColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
