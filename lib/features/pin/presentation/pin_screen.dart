import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../ui/components/buttons/pin_number_button.dart';
import '../../../ui/components/cards/pin_dots.dart';
import '../../../core/icons/m3_icons.dart';

/// PIN Screen
///
/// Figma frame: PIN (11:641)
/// PIN entry with numeric keyboard
class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';

  void _addNumber(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
      });

      // Check if PIN is complete and correct
      if (_pin.length == 6) {
        if (_pin == '123456') {
          // Navigate to Home screen
          context.go('/home');
        } else {
          // Show error or reset PIN
          setState(() {
            _pin = '';
          });
        }
      }
    }
  }

  void _deleteNumber() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

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
        body: SafeArea(
          child: Column(
            children: [
              // Header with back button and settings
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  top: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        M3Icons.arrowBack,
                        color: isDark
                            ? Colors.white
                            : AppColorSchemes.greysDarkGrey,
                        semanticLabel: 'Zurück',
                      ),
                      tooltip: 'Zurück', // WCAG 2.2
                      onPressed: () => context.go('/login-existing-user'),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColorSchemes.greysDarkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Enter PIN',
                      style: AppTypography.pinTitle.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColorSchemes.greysDarkGrey,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // PIN Dots
                    PinDots(filledDots: _pin.length),

                    const SizedBox(height: 64),

                    // Keyboard
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Row 1: 1, 2, 3
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PinNumberButton(
                                    number: '1',
                                    onPressed: () => _addNumber('1')),
                                PinNumberButton(
                                    number: '2',
                                    onPressed: () => _addNumber('2')),
                                PinNumberButton(
                                    number: '3',
                                    onPressed: () => _addNumber('3')),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.pinRowSpacing),

                            // Row 2: 4, 5, 6
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PinNumberButton(
                                    number: '4',
                                    onPressed: () => _addNumber('4')),
                                PinNumberButton(
                                    number: '5',
                                    onPressed: () => _addNumber('5')),
                                PinNumberButton(
                                    number: '6',
                                    onPressed: () => _addNumber('6')),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.pinRowSpacing),

                            // Row 3: 7, 8, 9
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PinNumberButton(
                                    number: '7',
                                    onPressed: () => _addNumber('7')),
                                PinNumberButton(
                                    number: '8',
                                    onPressed: () => _addNumber('8')),
                                PinNumberButton(
                                    number: '9',
                                    onPressed: () => _addNumber('9')),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.pinRowSpacing),

                            // Row 4: Fingerprint, 0, Delete
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Fingerprint button
                                InkWell(
                                  onTap: () {
                                    // Handle Fingerprint
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: 93,
                                    height: 64,
                                    child: Icon(
                                      M3Icons.fingerprint,
                                      size: 24,
                                      color: isDark
                                          ? Colors.white
                                          : AppColorSchemes.greysDarkGrey,
                                    ),
                                  ),
                                ),
                                // 0 button
                                PinNumberButton(
                                    number: '0',
                                    onPressed: () => _addNumber('0')),
                                // Backspace button
                                InkWell(
                                  onTap: _deleteNumber,
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: 93,
                                    height: 64,
                                    child: Icon(
                                      Icons.backspace,
                                      size: 24,
                                      color: isDark
                                          ? Colors.white
                                          : AppColorSchemes.greysDarkGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Pin forgotten link
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: TextButton(
                        onPressed: () {
                          // Handle PIN forgotten
                        },
                        child: Text(
                          'Pin forgotten?',
                          style: AppTypography.pinForgotten.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColorSchemes.greysDarkGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
