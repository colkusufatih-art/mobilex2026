import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';

/// Dropdown Form Field Component
///
/// Figma component: Dropdown Form (118:6262)
/// Used for Recipient Account and Address selection
class DropdownFormField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isDark;

  const DropdownFormField({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final textColor = AppColorSchemes.getTextColor(isDark);
    const labelColor = AppColorSchemes.greysMidGrey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    label,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                      letterSpacing: 0.12,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Value (multi-line supported)
                  Text(
                    value,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textColor,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              M3Icons.keyboardArrowDown,
              size: 24,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
