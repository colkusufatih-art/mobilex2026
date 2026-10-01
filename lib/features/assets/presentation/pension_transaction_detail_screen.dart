import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class PensionTransactionDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const PensionTransactionDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
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
              _buildHeader(isDark, context),
              
              // Transaction Header
              _buildTransactionHeader(isDark),
              
              const SizedBox(height: 16),
              
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Divider(
                  color: isDark
                      ? AppColorSchemes.darkCardBackground
                      : AppColorSchemes.greysLightGrey,
                  height: 1,
                  thickness: 1,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking text
                      _buildValueListElement(
                        label: 'Booking text',
                        value: title,
                        isDark: isDark,
                      ),
                      
                      // Valuta date
                      _buildValueListElement(
                        label: 'Valuta date',
                        value: _formatDate(date),
                        isDark: isDark,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Divider
                      Divider(
                        color: isDark
                            ? AppColorSchemes.darkCardBackground
                            : AppColorSchemes.greysLightGrey,
                        height: 1,
                        thickness: 1,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Start enquiry
                      _buildStartEnquiry(isDark),
                      
                      const SizedBox(height: 32),
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

  Widget _buildHeader(bool isDark, BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(date),
                  style: GoogleFonts.openSans(
                    color: subtitleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 2.19,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Amount
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerRight,
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
          ),
        ],
      ),
    );
  }

  Widget _buildValueListElement({
    required String label,
    required String value,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildStartEnquiry(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start enquiry',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start enquiry about this transaction',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              // Handle mail action
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.mail_outline,
                color: textColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    // Convert "29. June" to "29.06.2025" format
    final monthMap = {
      'January': '01',
      'February': '02',
      'March': '03',
      'April': '04',
      'May': '05',
      'June': '06',
      'July': '07',
      'August': '08',
      'September': '09',
      'October': '10',
      'November': '11',
      'December': '12',
    };
    
    for (final entry in monthMap.entries) {
      if (date.contains(entry.key)) {
        final day = date.split('.')[0].trim();
        return '$day.${entry.value}.2025';
      }
    }
    
    // If already in correct format, return as is
    return date;
  }
}

