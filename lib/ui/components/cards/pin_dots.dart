import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';

/// PIN Dots Indicator
///
/// Figma variant: Dots for PIN entry progress
/// Size: 12x12px dots, spacing 20px
class PinDots extends StatelessWidget {
  final int totalDots;
  final int filledDots;

  const PinDots({
    super.key,
    this.totalDots = 6,
    this.filledDots = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: index < filledDots
                    ? AppColorSchemes.pinDotActive
                    : AppColorSchemes.pinDotInactive,
                shape: BoxShape.circle,
              ),
            ),
            if (index < totalDots - 1) const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
