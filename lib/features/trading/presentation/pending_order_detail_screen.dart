import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Pending Order Detail Screen
///
/// Shows detailed information about a specific pending order
class PendingOrderDetailScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final String? orderType;

  const PendingOrderDetailScreen({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.orderType,
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

                      const SizedBox(height: 24),

                      // Cancel Order Button
                      _buildCancelOrderButton(context, isDark),

                      const SizedBox(height: 56),
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

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12),
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
                    subtitle ?? 'MMM | Valor 998421817 ISIN CH998421817',
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

          // Amount and Price Section
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
                                amount,
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

                      // Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Preis 14. Okt. 2011',
                              textAlign: TextAlign.right,
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

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: AppColorSchemes.getDividerColor(isDark),
              height: 1,
              thickness: 1,
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
          label: 'Amount',
          value: 'USD 200.00',
          subtitle: 'ca. USD 120.00',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Stock exchange',
          value: 'NYX',
          subtitle: 'USD',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Execution',
          value: 'USD 0.00',
          subtitle: '26.07.2025 - 00:00 | USD 200.00',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Type of execution',
          value: 'Limited',
          subtitle: 'Limit 98.50 %',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Order type',
          value: orderType ?? 'Buy',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Valid until',
          value: '30.09.2026',
          subtitle: 'Executed',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Order number',
          value: '153462-58',
          subtitle: 'Executed',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Portfolio',
          value: 'Growth',
          subtitle: '771534621506',
          isDark: isDark,
        ),
        _buildValueListItem(
          label: 'Settlement account',
          value: '1501 CHF',
          subtitle: 'CH28 0076 1001 5346 2150 1',
          isDark: isDark,
        ),
        _buildDivider(isDark),
        _buildValueListItem(
          label: 'Recorded',
          value: '23.09.2025 | 00:00 pm',
          subtitle: 'CH28 0076 1001 5346 2150 1',
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
                      if (subtitle != null && subtitle.isNotEmpty) ...[
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: AppSpacing.md),
      child: Divider(
        color: AppColorSchemes.getDividerColor(isDark),
        height: 1,
        thickness: 1,
      ),
    );
  }

  Widget _buildCancelOrderButton(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            _showCancelOrderBottomSheet(context, isDark);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorSchemes.greysDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Cancel order',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCancelOrderBottomSheet(BuildContext context, bool isDark) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CancelOrderBottomSheet(
        isDark: isDark,
        onYes: () {
          Navigator.of(context).pop(); // Close bottom sheet
          context.go('/trading'); // Navigate back to trading screen
        },
        onCancel: () {
          Navigator.of(context).pop(); // Close bottom sheet
        },
      ),
    );
  }

}

class _CancelOrderBottomSheet extends StatelessWidget {
  final bool isDark;
  final VoidCallback onYes;
  final VoidCallback onCancel;

  const _CancelOrderBottomSheet({
    required this.isDark,
    required this.onYes,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 35,
            height: 5,
            decoration: BoxDecoration(
              color: AppColorSchemes.greysMidGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (H1)
                Text(
                  'Cancel order',
                  style: GoogleFonts.openSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  'Do you want really cancel this order?',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Yes Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onYes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorSchemes.greysDarkGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColorSchemes.darkCardBackground
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'No',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

