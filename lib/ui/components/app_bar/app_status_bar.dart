import 'package:flutter/material.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/color_schemes.dart';

/// App Status Bar Component
/// 
/// Figma variant: Status Bar with time and icons
/// Height: 59px
class AppStatusBar extends StatelessWidget {
  final bool isDark;
  final String time;

  const AppStatusBar({
    super.key,
    this.isDark = false,
    this.time = '9:41',
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark ? Colors.white : AppColorSchemes.greysDarkGrey;
    final textColor = isDark ? Colors.white : AppColorSchemes.greysDarkGrey;

    return Container(
      height: AppSpacing.statusBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time indicator
          Container(
            height: 21,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),

          // Status icons
          Row(
            children: [
              Icon(
                M3Icons.signalCellular,
                size: AppSpacing.statusIconSize,
                color: iconColor,
              ),
              const SizedBox(width: AppSpacing.statusIconSpacing),
              Icon(
                M3Icons.wifi,
                size: AppSpacing.statusIconSize,
                color: iconColor,
              ),
              const SizedBox(width: AppSpacing.statusIconSpacing),
              Icon(
                M3Icons.battery,
                size: AppSpacing.statusIconBatterySize,
                color: iconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

