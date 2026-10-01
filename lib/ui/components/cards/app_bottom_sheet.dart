import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/color_schemes.dart';

/// App Bottom Sheet Component
///
/// Figma variant: Bottom Sheet with handle and list items
/// Height: 236px
class AppBottomSheet extends StatelessWidget {
  final List<BottomSheetItem> items;
  final bool isDark;

  const AppBottomSheet({
    super.key,
    required this.items,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;
    final textColor = isDark ? Colors.white : AppColorSchemes.greysDarkGrey;
    final iconBgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Container(
      height: AppSpacing.bottomSheetHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: AppSpacing.bottomSheetHandleWidth,
            height: AppSpacing.bottomSheetHandleHeight,
            decoration: const BoxDecoration(
              color: AppColorSchemes.bottomSheetHandle,
              borderRadius: AppRadius.bottomSheetHandle,
            ),
          ),

          // List items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: item.onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: AppSpacing.bottomSheetIconSize,
                          height: AppSpacing.bottomSheetIconSize,
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: AppRadius.iconButton,
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  BottomSheetItem({
    required this.title,
    required this.icon,
    this.onTap,
  });
}
