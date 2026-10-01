import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Performance Detail Screen
///
/// Shows detailed performance information for a specific month/year
class PerformanceDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String percentage;
  final String change;
  final bool isPositive;

  const PerformanceDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.percentage,
    required this.change,
    required this.isPositive,
  });

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

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Transaction Header
                      _buildTransactionHeader(isDark),

                      // Content List
                      _buildContentList(isDark),

                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              const AppBottomNavigation(activeRoute: '/assets'),
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
            onTap: () => context.pop(),
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
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const positiveColor = Color(0xFF34C759);
    const negativeColor = Color(0xFFC00024);
    final performanceColor = isPositive ? positiveColor : negativeColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 343,
                  child: Text(
                    title,
                    style: GoogleFonts.openSans(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 343,
                  child: Text(
                    subtitle,
                    style: GoogleFonts.openSans(
                      color: subtitleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 2.19,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Amount and YTD Section
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Amount
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'CHF',
                                      style: GoogleFonts.openSans(
                                        color: AppColorSchemes.primaryDarkYellow,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        height: 1.25,
                                      ),
                                    ),
                                    TextSpan(
                                      text: amount.startsWith('CHF ')
                                          ? ' ${amount.substring(4)}'
                                          : amount,
                                      style: GoogleFonts.openSans(
                                        color: textColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        height: 1.25,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 2),

                      // YTD Performance
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'YTD',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.openSans(
                              color: performanceColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 2.19,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: performanceColor,
                            size: 24,
                          ),
                          Flexible(
                            child: Text(
                              '$percentage | $change',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.openSans(
                                color: performanceColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 2.19,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList(bool isDark) {
    return Column(
      children: [
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Januar 2025',
          value: 'CHF 289\'312.00',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Success',
          value: '$percentage | $change',
          isPositive: isPositive,
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Net cash flow',
          value: 'CHF 0.00',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: '∅ Invested capital',
          value: 'CHF 282\'432.12',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Performance (TWR)',
          value: percentage,
          isPositive: isPositive,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildValueListItem({
    required String label,
    required String value,
    bool? isPositive,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final valueColor = isPositive != null
        ? (isPositive ? const Color(0xFF34C759) : const Color(0xFFC00024))
        : textColor;

    // Check if this should be displayed horizontally
    final bool isHorizontal = label == 'Success' || 
                              label == 'Performance (TWR)' ||
                              label == 'Januar 2025' ||
                              label == 'Net cash flow' ||
                              label == '∅ Invested capital';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: isHorizontal
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (isPositive != null)
                            Icon(
                              isPositive == true
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: valueColor,
                              size: 24,
                            ),
                          Text(
                            value,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: valueColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: valueColor,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(
        color: AppColorSchemes.getDividerColor(isDark),
        height: 1,
        thickness: 1,
      ),
    );
  }
}

