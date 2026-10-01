import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../ui/components/buttons/app_filled_button.dart';
import '../../../ui/components/buttons/app_outlined_button.dart';
import '../../../core/icons/m3_icons.dart';

/// Login Existing User Screen
///
/// Figma frame: Login – Existing User (23:4482)
/// Shows personalized welcome with user name and action buttons
/// Background image extends to top of screen
/// EUR switch: when enabled, app displays EUR instead of CHF
class LoginExistingUserScreen extends StatefulWidget {
  const LoginExistingUserScreen({super.key});

  @override
  State<LoginExistingUserScreen> createState() => _LoginExistingUserScreenState();
}

class _LoginExistingUserScreenState extends State<LoginExistingUserScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        body: Column(
          children: [
            // Background image with 496px height
            SizedBox(
              height: 496.0,
              width: double.infinity,
              child: Image.asset(
                'assets/img/building.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/bild.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            // Content section
            Expanded(
              child: Column(
                children: [
                  // Welcome Text Section with User Name - left aligned with 16px padding
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.md,
                      top: AppSpacing.md,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome ',
                            style: AppTypography.welcomeTitle.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : AppColorSchemes.greysDarkGrey,
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            'Reto Haldner',
                            style: AppTypography.welcomeTitleBold.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : AppColorSchemes.greysDarkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Container with buttons
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      children: [
                        AppFilledButton(
                          text: 'Login',
                          onPressed: () {
                            context.go('/pin');
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppOutlinedButton(
                                    text: 'Connect',
                                    icon: M3Icons.devices,
                                    isDark: isDark,
                                    onPressed: () {
                                      // Handle connect action
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AppOutlinedButton(
                                    text: 'Settings',
                                    icon: M3Icons.settings,
                                    isDark: isDark,
                                    onPressed: () {
                                      context.go('/login-settings');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Currency row: label on left, switch on right, centered vertically
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildCurrencyLabel(context, isDark),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: _buildCurrencySwitch(context, isDark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 56.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyLabel(BuildContext context, bool isDark) {
    final currencyNotifier = CurrencyScope.of(context)?.notifier;
    if (currencyNotifier == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: currencyNotifier,
      builder: (context, _) {
        final textColor =
            isDark ? Colors.white : AppColorSchemes.greysDarkGrey;
        final label = currencyNotifier.useEur ? 'EUR' : 'CHF';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(M3Icons.language, size: 20, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ) ??
                  TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrencySwitch(BuildContext context, bool isDark) {
    final currencyNotifier = CurrencyScope.of(context)?.notifier;
    if (currencyNotifier == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: currencyNotifier,
      builder: (context, _) {
        return Switch(
          value: currencyNotifier.useEur,
          onChanged: (value) => currencyNotifier.setUseEur(value),
          activeTrackColor: AppColorSchemes.secondaryOrange,
          activeThumbColor: Colors.white,
        );
      },
    );
  }
}
