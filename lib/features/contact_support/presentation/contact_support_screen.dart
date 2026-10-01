import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/bottom_sheets/personal_advisor_sheet.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart' show ValueListElement, ValueListEntry;

/// Contact & Support Screen
///
/// Displays contact options and support information
class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          'Contact & Support',
                          style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: AppColorSchemes.getTextColor(isDark),
                            height: 1.25,
                          ),
                        ),
                      ),

                      // Action Buttons
                      _buildActionButtons(context, isDark),

                      const SizedBox(height: 24),

                      // Personal advisor
                      ValueListElement(
                        entry: ValueListEntry(
                          label: 'Personal advisor',
                          value: 'Marcell Hoffmann\nCrealogix Advisor Zürich\n+41 76 835 77 99',
                          trailingAction: _buildActionButton(context, isDark),
                        ),
                        isDark: isDark,
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: isDark
                              ? AppColorSchemes.darkCardBackground
                              : AppColorSchemes.greysLightGrey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),

                      // Support Options
                      _buildSupportOption(
                        icon: Icons.credit_card_off_outlined,
                        title: 'Block card',
                        isDark: isDark,
                        onTap: () {
                          // Handle block card
                        },
                      ),

                      _buildSupportOption(
                        icon: Icons.file_open_outlined,
                        title: 'Instructions',
                        isDark: isDark,
                        onTap: () {
                          // Handle instructions
                        },
                      ),

                      _buildSupportOption(
                        icon: Icons.info_outline,
                        title: 'FAQ',
                        isDark: isDark,
                        onTap: () {
                          // Handle FAQ
                        },
                      ),

                      _buildSupportOption(
                        icon: Icons.outlined_flag,
                        title: 'Report error',
                        isDark: isDark,
                        onTap: () {
                          // Handle report error
                        },
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.go('/more'),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                M3Icons.arrowBack,
                color: textColor,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40), // Balance width
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSquaredButton(
            icon: Icons.call_outlined,
            text: 'Call',
            isDark: isDark,
            onTap: () {
              // Handle call
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildSquaredButton(
            icon: Icons.question_answer_outlined,
            text: 'Message',
            isDark: isDark,
            onTap: () {
              context.push('/messages/new');
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildSquaredButton(
            icon: M3Icons.supportAgent,
            text: 'Advisory',
            isDark: isDark,
            onTap: () {
              // Handle advisory
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSquaredButton({
    required IconData icon,
    required String text,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    final borderRadius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: AppColorSchemes.getCardBackgroundColor(isDark),
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: AppColorSchemes.getTextColor(isDark),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColorSchemes.getTextColor(isDark),
                  height: 1.43,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final bgColor = AppColorSchemes.getCardBackgroundColor(isDark);

    return InkWell(
      onTap: () {
        _showPersonalAdvisorSheet(context, isDark);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          M3Icons.arrowOutward,
          color: textColor,
          size: 24,
        ),
      ),
    );
  }

  void _showPersonalAdvisorSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const PersonalAdvisorSheet(),
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
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
}

