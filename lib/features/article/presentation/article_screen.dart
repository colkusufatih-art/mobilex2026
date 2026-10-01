import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Article Screen
///
/// Figma frame: Article Page
/// Displays detailed article content with background image.
class ArticleScreen extends StatefulWidget {
  final String title;
  final String subtitle;

  const ArticleScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
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
        body: Stack(
          children: [
            // Background Image
            _buildBackgroundImage(isDark),

            // Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(isDark),
                  Expanded(
                    child: _buildContent(isDark),
                  ),
                  const AppBottomNavigation(activeRoute: '/article'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
    );
  }

  Widget _buildHeader(bool isDark) {
    final iconColor = isDark
        ? AppColorSchemes.darkTextPrimary
        : AppColorSchemes.greysDarkGrey;
    final textColor = isDark
        ? AppColorSchemes.darkTextPrimary
        : AppColorSchemes.greysDarkGrey;

    return Container(
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Back Button (Left)
          InkWell(
            onTap: () => context.go('/home'),
            child: Icon(
              M3Icons.arrowBack,
              color: iconColor,
              size: 24,
            ),
          ),

          const Spacer(),

          // Insights Title (Center)
          Text(
            'Insights',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          const Spacer(),

          // Share Button (Right)
          InkWell(
            onTap: () {
              // Handle share action
            },
            child: Icon(
              M3Icons.share,
              color: iconColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Background Image Container
          Container(
            width: double.infinity,
            height: 267,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/img/Image_Web_Person_Woman-Man-sitting-laptop.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Filter Chips
          Row(
            children: [
              _buildFilterChip('Marktanalysen', true, isDark),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip('Börse', false, isDark),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Article Title
          Text(
            'Start your own Business with Crealogix',
            style: GoogleFonts.openSans(
              fontSize: 28,
              fontWeight: FontWeight.normal,
              color: isDark
                  ? AppColorSchemes.darkTextPrimary
                  : AppColorSchemes.greysDarkGrey,
              height: 1.25,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Article Content
          _buildArticleContent(isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    final chipColor =
        isDark ? AppColorSchemes.getCardBackgroundColor(isDark) : Colors.white;
    final textColor = isDark
        ? AppColorSchemes.darkTextPrimary
        : AppColorSchemes.greysDarkGrey;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
        // Kein Border für beide Chips
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleContent(bool isDark) {
    final textColor =
        isDark ? AppColorSchemes.darkTextPrimary : const Color(0xFF333333);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                'This fall, the markets are once again testing their limits. Stocks ended September at record highs, bonds regained strength with the US Federal Reserve\'s first interest rate cut, and gold retained its luster. When such boundaries shift, it\'s not just prices that change, but also the way investors think about risk and opportunity.\n\nFor if there is one paradox in the financial world, it is this: limits are both feared and valued. Investors rely on them for clarity and confidence, even though the markets constantly test them. In this environment, transparency becomes just as important as performance.\n\n',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: textColor,
              height: 1.75,
              letterSpacing: 0.1,
            ),
          ),
          TextSpan(
            text: 'Table of contents\n\n',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.75,
              letterSpacing: 0.1,
            ),
          ),
          TextSpan(
            text:
                '• The market at a glance: No limits to the upside\n• Key findings:\n  • Equity performance\n  • Bond performance\n  • Commodities, currencies, and digital assets performance\n• Let\'s be clear: The extent of our pension gap\n• Pillar 3a with 0% management fees* until December 2026',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: textColor,
              height: 1.75,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
