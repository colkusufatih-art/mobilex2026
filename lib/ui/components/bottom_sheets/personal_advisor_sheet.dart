import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';

/// Personal Advisor Bottom Sheet
///
/// Bottom sheet for displaying contact options (Personal advisor, E-banking Helpline, Trading Hotline)
class PersonalAdvisorSheet extends StatelessWidget {
  const PersonalAdvisorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          _buildHandle(isDark),

          // Content
          Flexible(
            child: _buildContent(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 35,
      height: 5,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysMidGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: 24,
        bottom: 56,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Personal advisor Card
          _buildContactCard(
            title: 'Personal advisor',
            details: '+41 76 835 77 99 | Marcell Hoffmann',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // E-banking Helpline Card
          _buildContactCard(
            title: 'E-banking Helpline',
            phoneNumber: '+41 76 835 77 99',
            openingHours: 'Monday – Friday',
            openingHoursTime: 'From 07:30 to 17:30',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Trading Hotline Card
          _buildContactCard(
            title: 'Trading Hotline',
            phoneNumber: '0800 055 555',
            openingHours: 'Monday – Friday',
            openingHoursTime: 'From 07:30 to 17:30',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    String? details,
    String? phoneNumber,
    String? openingHours,
    String? openingHoursTime,
    required bool isDark,
  }) {
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);
    final titleColor = AppColorSchemes.getTextColor(isDark);
    const detailsColor = AppColorSchemes.greysMidGrey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Wrap: Title, Details/Phone
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Details or Phone Number
                    if (details != null)
                      Text(
                        details,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: detailsColor,
                          height: 1.5,
                          letterSpacing: 0.12,
                        ),
                      )
                    else if (phoneNumber != null)
                      Text(
                        phoneNumber,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: detailsColor,
                          height: 1.5,
                          letterSpacing: 0.12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom: Opening hours (right-aligned)
          if (openingHours != null && openingHoursTime != null) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    openingHours,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: titleColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    openingHoursTime,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: detailsColor,
                      height: 1.5,
                      letterSpacing: 0.12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

