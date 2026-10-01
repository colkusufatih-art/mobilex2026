import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class AssetsGraphScreen extends StatelessWidget {
  const AssetsGraphScreen({super.key});

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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Total Assets Title
                      _buildTotalAssetsTitle(isDark),

                      const SizedBox(height: 40),

                      // Ring Chart
                      _buildRingChart(isDark),

                      const SizedBox(height: 40),

                      // Legend
                      _buildLegend(isDark),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              const AppBottomNavigation(activeRoute: '/home'),
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

  Widget _buildTotalAssetsTitle(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            M3Icons.accountBalanceWallet,
            size: 18,
            color: textColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Total Assets',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingChart(bool isDark) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _RingChartPainter(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'CHF ',
                      style: GoogleFonts.openSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColorSchemes.primaryDarkYellow, // Active color
                        height: 1.25,
                      ),
                    ),
                    TextSpan(
                      text: '148\'211.14',
                      style: GoogleFonts.openSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColorSchemes.getTextColor(isDark),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    final legendItems = [
      _LegendItem(
        color: const Color(0xFF5BC5F2), // Light blue
        label: 'Accounts',
        percentage: '15%',
      ),
      _LegendItem(
        color: const Color(0xFF417691), // Dark blue
        label: 'Savings',
        percentage: '25%',
      ),
      _LegendItem(
        color: const Color(0xFF34C759), // Dark green
        label: 'Shares',
        percentage: '40%',
      ),
      _LegendItem(
        color: const Color(0xFF00C3D0), // Teal/cyan
        label: 'Investments',
        percentage: '5%',
      ),
      _LegendItem(
        color: const Color(0xFF4CAF50), // Bright green
        label: 'Mortgages',
        percentage: '15%',
      ),
    ];

    return Column(
      children: legendItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.label,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ),
              Text(
                item.percentage,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _LegendItem {
  final Color color;
  final String label;
  final String percentage;

  _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
  });
}

class _RingChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    const strokeWidth = 40.0;

    // Data: [percentage, color]
    final segments = [
      [15.0, const Color(0xFF5BC5F2)], // Accounts - Light blue
      [25.0, const Color(0xFF417691)], // Savings - Dark blue
      [40.0, const Color(0xFF34C759)], // Shares - Dark green
      [5.0, const Color(0xFF00C3D0)], // Investments - Teal/cyan
      [15.0, const Color(0xFF4CAF50)], // Mortgages - Bright green
    ];

    double startAngle = -90 * (3.14159 / 180); // Start at top (-90 degrees)

    for (final segment in segments) {
      final percentage = segment[0] as double;
      final color = segment[1] as Color;
      final sweepAngle = (percentage / 100) * 2 * 3.14159;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

