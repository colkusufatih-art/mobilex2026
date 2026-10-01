import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Position Detail Screen
///
/// Shows detailed information about a specific position
class PositionDetailScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String? quantity;
  final String? percentage;
  final bool? isPositive;

  const PositionDetailScreen({
    super.key,
    required this.title,
    required this.amount,
    this.quantity,
    this.percentage,
    this.isPositive,
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
                      _buildTransactionHeader(context, isDark),

                      const SizedBox(height: 32),

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

  Widget _buildTransactionHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const negativeColor = Color(0xFFC00024);

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
                if (quantity != null)
                  SizedBox(
                    width: 343,
                    child: Text(
                      quantity!,
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
                              child: Text(
                                context.withAppCurrency(amount),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.openSans(
                                  color: textColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 2),

                      // YTD Performance
                      if (percentage != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'YTD',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.openSans(
                                color: isPositive == true
                                    ? const Color(0xFF34C759)
                                    : negativeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 2.19,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isPositive == true
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: isPositive == true
                                  ? const Color(0xFF34C759)
                                  : negativeColor,
                              size: 24,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                percentage!,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.openSans(
                                  color: isPositive == true
                                      ? const Color(0xFF34C759)
                                      : negativeColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 2.19,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 2),

                      // Graph (placeholder)
                      const SizedBox(
                        width: 249,
                        height: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [],
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

  Widget _buildContentList(bool isDark) {
    return Column(
      children: [
        _buildValueListItem(
          label: 'Position',
          value: title,
          subtitle: quantity,
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Currency',
          value: 'CHF',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Sektor',
          value: 'Various services CLX',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Inventory',
          value: '2000 Pcs.',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Price/Rate CHF',
          value: 'CHF 98.32',
          subtitle: 'January 2025',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Exchange rate',
          value: '0.8971',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Market price ∅ CHF',
          value: '0.8971',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Exchange rate USD/CHF',
          value: '0.8971',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Market value',
          value: 'CHF 1\'758.32',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Interest',
          value: 'CHF 11.96',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Share of portfolio value in %',
          value: '0.68%',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Unrealized gain/loss',
          value: '< 0.01% / CHF 0.00',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Valor',
          value: '< 0.01% / CHF 0.00',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'ISIN',
          value: '–',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildValueListItem({
    required String label,
    required String value,
    String? subtitle,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Row(
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
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                            height: 1.5,
                          ),
                        ),
                      ],
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

