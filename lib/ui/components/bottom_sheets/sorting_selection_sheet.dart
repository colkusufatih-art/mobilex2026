import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';

/// Sorting Selection Bottom Sheet
///
/// Bottom sheet for selecting sorting options
class SortingSelectionSheet extends StatelessWidget {
  final String selectedSorting;
  final Function(String) onSortingSelected;

  const SortingSelectionSheet({
    super.key,
    required this.selectedSorting,
    required this.onSortingSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          _buildHandle(),
          const SizedBox(height: AppSpacing.md),

          // Title
          _buildTitle(isDark),
          const SizedBox(height: AppSpacing.md),

          // Sorting Options
          Flexible(
            child: _buildSortingOptions(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 35,
      height: 5,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysMidGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: AppSpacing.md,
        bottom: 16,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectedSorting,
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSortingOptions(BuildContext context, bool isDark) {
    final options = [
      'Investmentsgroups',
      'Currency',
      'Industry',
      'Region',
    ];

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: 56,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return _buildSortingOption(option, isDark, context);
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemCount: options.length,
    );
  }

  Widget _buildSortingOption(String option, bool isDark, BuildContext context) {
    final isSelected = selectedSorting == option;
    final textColor = AppColorSchemes.getTextColor(isDark);
    final backgroundColor = isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : AppColorSchemes.getCardBackgroundColor(isDark);
    final checkColor = isDark
        ? AppColorSchemes.primaryDarkYellow
        : AppColorSchemes.greysDarkGrey;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: () {
          onSortingSelected(option);
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  M3Icons.check,
                  size: 24,
                  color: checkColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

