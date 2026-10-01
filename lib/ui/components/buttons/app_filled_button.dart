import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/color_schemes.dart';

/// App Filled Button (Primary Action)
///
/// Figma variant: Button filled with #333333 background
/// Size: Height 56px, Border Radius 8px
class AppFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const AppFilledButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorSchemes.lightButtonBackground,
          foregroundColor: AppColorSchemes.lightButtonText,
          disabledBackgroundColor: AppColorSchemes.greysMidGrey,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: AppTypography.buttonText,
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: AppTypography.buttonText,
                  ),
      ),
    );
  }
}
