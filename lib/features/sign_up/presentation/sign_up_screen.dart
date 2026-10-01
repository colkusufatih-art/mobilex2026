import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🔧 diese Pfade ggf. anpassen:
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/core/theme/typography.dart';
import 'package:mobilex2025/core/theme/color_schemes.dart'; // enthält AppColorSchemes (falls vorhanden)
import 'package:mobilex2025/ui/components/app_bar/app_status_bar.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import 'package:mobilex2025/ui/components/buttons/app_outlined_button.dart';
import 'package:mobilex2025/core/icons/m3_icons.dart';

/// Sign Up Screen
///
/// Figma frame: Sign up (23:4450)
/// Welcome screen with building background and action buttons
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sauberer als setSystemUIOverlayStyle im Build: AnnotatedRegion
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        body: SafeArea(
          child: Stack(
            children: [
              // Background image (mit Fallback über errorBuilder)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: AppSpacing.imageSectionHeight,
                  child: Image.asset(
                    'assets/img/building.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback-Bild, wenn das erste Asset fehlt/fehlschlägt
                      return Image.asset(
                        'assets/images/bild.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),

              // Status bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppStatusBar(isDark: isDark),
              ),

              // Content
              Column(
                children: [
                  const SizedBox(height: AppSpacing.imageSectionHeight),

                  // Welcome Text Section
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Welcome to the Crealogix',
                          style: AppTypography.welcomeTitle.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColorSchemes.greysDarkGrey,
                          ),
                        ),
                        const SizedBox(height: 0),
                        Text(
                          'Mobile Banking',
                          style: AppTypography.welcomeTitleBold.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColorSchemes.greysDarkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom Container
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      children: [
                        AppFilledButton(
                          // 🔧 Falls deine Komponente statt `text:` ein `child:` erwartet, dann anpassen:
                          text: 'Get started',
                          onPressed: () {
                            // Handle navigation
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: AppOutlinedButton(
                                text: 'Connect',
                                icon: M3Icons.devices,
                                isDark: isDark,
                                onPressed: () {
                                  // Handle connect
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: AppOutlinedButton(
                                text: 'Help',
                                icon: M3Icons.help,
                                isDark: isDark,
                                onPressed: () {
                                  // Handle help
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
