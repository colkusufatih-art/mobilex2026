import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Article Loans Screen
///
/// Figma frame: Article Page for Loans
/// Displays detailed article content about low-cost loans with background image.
class ArticleLoansScreen extends StatefulWidget {
  final String title;
  final String subtitle;

  const ArticleLoansScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ArticleLoansScreen> createState() => _ArticleLoansScreenState();
}

class _ArticleLoansScreenState extends State<ArticleLoansScreen> {
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
            _buildBackgroundImage(),
            
            // Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(isDark),
                  Expanded(
                    child: _buildContent(isDark),
                  ),
                  const AppBottomNavigation(activeRoute: '/article-loans'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
    );
  }

  Widget _buildHeader(bool isDark) {
    final iconTextColor = AppColorSchemes.getTextColor(isDark);
    
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
              color: isDark
                  ? AppColorSchemes.darkTextPrimary
                  : AppColorSchemes.greysDarkGrey,
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
              color: iconTextColor,
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
              color: isDark
                  ? AppColorSchemes.darkTextPrimary
                  : AppColorSchemes.greysDarkGrey,
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
              color: isDark
                  ? AppColorSchemes.darkBackground
                  : AppColorSchemes.lightBackground,
              image: const DecorationImage(
                image: AssetImage('assets/img/GettyImages-1309085617.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Filter Chips
          Row(
            children: [
              _buildFilterChip('Financing', true, isDark),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip('Loans', false, isDark),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Article Title
          Text(
            'Benefit from our low-cost loans',
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
    final chipColor = AppColorSchemes.getCardBackgroundColor(isDark);
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
                'Financing your dreams has never been easier. Our low-cost loan solutions provide you with the financial flexibility you need to achieve your goals, whether it\'s starting a business, purchasing a home, or investing in your future.\n\nWith competitive interest rates and flexible repayment terms, we make it simple for you to access the capital you need when you need it most.\n\n',
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
                '• Personal loans with competitive rates\n• Business financing solutions\n• Home loan options\n• Investment loan programs\n• Flexible repayment terms\n• Quick approval process\n• Expert financial advice\n• 24/7 customer support',
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
