import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/color_schemes.dart';

/// App Outlined Button (Secondary Action)
///
/// Figma variant: Action Bar Button with transparent border
/// Size: Height 35px
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isDark;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppColorSchemes.greysDarkGrey;

    return SizedBox(
      height: AppSpacing.buttonSecondaryHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 24,
          color: textColor,
        ),
        label: Text(
          text,
          style: AppTypography.buttonTextSecondary.copyWith(color: textColor),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
