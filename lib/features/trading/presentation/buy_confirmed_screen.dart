import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';

class BuyConfirmedScreen extends StatefulWidget {
  final String title;
  final String amount;

  const BuyConfirmedScreen({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  State<BuyConfirmedScreen> createState() => _BuyConfirmedScreenState();
}

class _BuyConfirmedScreenState extends State<BuyConfirmedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      context.go('/trading');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;
    final textColor = AppColorSchemes.getTextColor(isDark);
    final accent = AppColorSchemes.primaryDarkYellow;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: isDark
                        ? accent.withValues(alpha: 0.12)
                        : const Color(0xFFFFF2D9),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: isDark ? Colors.black : Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Order confirmed',
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Order has been placed',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColorSchemes.greysMidGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

