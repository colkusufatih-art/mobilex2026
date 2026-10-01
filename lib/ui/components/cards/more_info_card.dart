import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';

/// More Info Card Component
///
/// A reusable card component for displaying additional information
/// with icon, title, description, and optional action
class MoreInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onTap;
  final bool isDark;

  const MoreInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: Colors.white,
        border: Border.all(
          color: AppColorSchemes.greysLightGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: AppColorSchemes.primaryDarkYellow,
                  size: 24,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.greysDarkGrey,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColorSchemes.greysMidGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Arrow or Text
              if (actionText != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  actionText!,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColorSchemes.primaryDarkYellow,
                  ),
                ),
              ] else ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  M3Icons.arrowForward,
                  color: AppColorSchemes.greysMidGrey,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
