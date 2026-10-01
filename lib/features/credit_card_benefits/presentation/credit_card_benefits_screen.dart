import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Credit Card Benefits Screen
///
/// Based on Cards Benefits Screen
/// Displays Credit Card information with marketing cards
class CreditCardBenefitsScreen extends StatefulWidget {
  const CreditCardBenefitsScreen({super.key});

  @override
  State<CreditCardBenefitsScreen> createState() =>
      _CreditCardBenefitsScreenState();
}

class _CreditCardBenefitsScreenState extends State<CreditCardBenefitsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(isDark),
              _buildDivider(isDark),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                          height: 32), // Spacing from Header to Title
                      _buildTitle(isDark),
                      const SizedBox(height: 32), // Spacing from Figma
                      _buildMarketingCards(isDark),
                      const SizedBox(height: 42), // Spacing from Figma
                      _buildContent(isDark),
                      const SizedBox(
                          height:
                              42), // Spacing between text and more-info-card
                      _buildMoreInfoCard(isDark),
                      const SizedBox(height: 32), // Spacing from Figma
                      _buildBottomButton(),
                      const SizedBox(
                          height: 56), // Spacing to bottom navigation
                    ],
                  ),
                ),
              ),
              const AppBottomNavigation(activeRoute: '/credit-card-benefits'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final iconTextColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => context.go('/home'),
            child: Icon(
              M3Icons.arrowBack,
              color: iconTextColor,
              size: 24,
            ),
          ),

          const Spacer(),

          // Benefits Text (centered)
          Text(
            'Benefits',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600, // SemiBold
              color: iconTextColor,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      color: AppColorSchemes.getDividerColor(isDark),
    );
  }

  Widget _buildTitle(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        'Order your Crealogix Credit card',
        style: GoogleFonts.openSans(
          fontSize: 28,
          fontWeight: FontWeight.normal, // Regular
          color: textColor,
          height: 1.25, // lineHeightPx: 35
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildMarketingCards(bool isDark) {
    return SizedBox(
      height: 248,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _buildMarketingCard(
            title: 'Grow your wealth',
            description: 'Benefit from high interest rates paid out monthly.',
            imagePath: 'assets/img/Graphic-pillar3a.png',
            isDark: isDark,
          ),
          const SizedBox(width: AppSpacing.md),
          _buildMarketingCard(
            title: 'Available at any time',
            description:
                'Access your savings anytime. Simple and without restrictions.',
            imagePath: 'assets/img/Graphic-wallet.png',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildMarketingCard({
    required String title,
    required String description,
    required String imagePath,
    required bool isDark,
  }) {
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);
    final titleColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      width: 343,
      height: 248,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
              letterSpacing: 0.1,
              height: 1.56, // lineHeightPx: 28
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              description,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColorSchemes.greysMidGrey, // #888888
                letterSpacing: 0.1,
                height: 1.75, // lineHeightPx: 28
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Table of contents\n\n',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Bold for Table of contents
                color: textColor,
                letterSpacing: 0.1,
                height: 1.75, // lineHeightPx: 28
              ),
            ),
            TextSpan(
              text:
                  'The market at a glance: No limits to the upside\nKey findings:\n• Equity performance\n• Bond performance\n• Commodities, currencies, and digital assets performance\nLet\'s be clear: The extent of our pension gap\nPillar 3a with 0% management fees* until December 2026',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
                letterSpacing: 0.1,
                height: 1.75, // lineHeightPx: 28
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildMoreInfoCard(bool isDark) {
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);
    final iconTextColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            M3Icons.helpOutline,
            color: iconTextColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Do you have any questions?',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: iconTextColor,
              letterSpacing: 0.1,
              height: 1.75, // lineHeightPx: 28
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'More information',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600, // SemiBold
              color: AppColorSchemes.primaryDarkYellow, // #ffa814
              letterSpacing: 0.1,
              height: 1.75, // lineHeightPx: 28
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      height: 56,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysDarkGrey, // #333333
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // Handle start savings action
        },
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            'Start with your savings',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
