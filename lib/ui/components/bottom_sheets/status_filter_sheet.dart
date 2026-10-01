import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// Status Filter Bottom Sheet
///
/// Bottom sheet for selecting a status filter
class StatusFilterSheet extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const StatusFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

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

          // Header
          _buildHeader(isDark),

          // Status Options
          Flexible(
            child: _buildStatusList(context, isDark),
          ),

          // Search Button
          _buildSearchButton(context, isDark),
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

  Widget _buildHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Status',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusList(BuildContext context, bool isDark) {
    final statusOptions = [
      'Forwarded',
      'Deleted',
      'Recorded',
      'Signature',
      'Deletion',
      'Pendant',
      'Cancelled',
      'Not Confirmed',
      'Posted',
    ];

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: 56,
      ),
      itemCount: statusOptions.length,
      itemBuilder: (context, index) {
        final status = statusOptions[index];
        final isSelected = selectedStatus == status;
        return _buildStatusCard(context, status, isSelected, isDark);
      },
    );
  }

  Widget _buildStatusCard(BuildContext context, String status, bool isSelected, bool isDark) {
    final cardColor = isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : AppColorSchemes.getCardBackgroundColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);
    final checkColor = isDark
        ? AppColorSchemes.primaryDarkYellow
        : AppColorSchemes.greysDarkGrey;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: () {
          onStatusSelected(status);
          Navigator.of(context).pop();
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  status,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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

  Widget _buildSearchButton(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: 56,
      ),
      child: AppFilledButton(
        text: 'Search',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
