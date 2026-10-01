import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class MortgageDetailScreen extends StatelessWidget {
  final String title;
  final String amount;

  const MortgageDetailScreen({
    super.key,
    required this.title,
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
              _buildTransactionHeader(context, isDark),
              
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Fixed-rate mortgage
                      _buildValueListElement(
                        label: 'Fixed-rate mortgage',
                        value: '998421825',
                        isDark: isDark,
                      ),
                      
                      // Valid until
                      _buildValueListElement(
                        label: 'Valid until',
                        value: '30.12.2030',
                        isDark: isDark,
                      ),
                      
                      // Interest rate
                      _buildValueListElement(
                        label: 'Interest rate',
                        value: '0.90%',
                        isDark: isDark,
                      ),
                      
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

  Widget _buildTransactionHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final displayAmount =
        context.withAppCurrency(amount.startsWith('CHF ') ? amount : 'CHF $amount');
    final currency = context.appCurrency;
    
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
                      text: currency,
                      style: GoogleFonts.openSans(
                        color: AppColorSchemes.primaryDarkYellow,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    TextSpan(
                      text: displayAmount.startsWith('$currency ')
                          ? ' ${displayAmount.substring(currency.length + 1)}'
                          : displayAmount,
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
}

