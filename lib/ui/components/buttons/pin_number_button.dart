import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';

/// PIN Number Button Component
///
/// Figma variant: Number Button for PIN keyboard
/// Size: 93x64px
class PinNumberButton extends StatelessWidget {
  final String number;
  final VoidCallback? onPressed;
  final Widget? bottomIcon;

  const PinNumberButton({
    super.key,
    required this.number,
    this.onPressed,
    this.bottomIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: AppSpacing.pinNumberButtonSize,
      height: AppSpacing.pinNumberButtonHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: AppTypography.numberButton.copyWith(
                  color: isDark ? Colors.white : const Color(0xFF333333),
                ),
              ),
              if (bottomIcon != null) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: bottomIcon,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
