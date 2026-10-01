import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';

/// Notifications Bottom Sheet
///
/// Bottom sheet displaying notifications with External Link Cards
class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          _buildHandle(isDark),

          // Content
          Flexible(
            child: _buildContent(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 35,
      height: 5,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysMidGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: 16),
          
          // Payments Card
          _buildNotificationCard(
            context: context,
            isDark: isDark,
            title: 'Payments',
            newCount: 3,
            onTap: () {
              Navigator.of(context).pop();
              context.go('/payments');
            },
          ),
          
          const SizedBox(height: 8),
          
          // Bank statement Card
          _buildNotificationCard(
            context: context,
            isDark: isDark,
            title: 'Bank statement',
            newCount: 1,
            onTap: () {
              Navigator.of(context).pop();
              context.go('/documents');
            },
          ),
          
          const SizedBox(height: 8),
          
          // Messages Card
          _buildNotificationCard(
            context: context,
            isDark: isDark,
            title: 'Messages',
            newCount: 5,
            onTap: () {
              Navigator.of(context).pop();
              context.go('/messages');
            },
          ),
          
          const SizedBox(height: 56),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required int newCount,
    required VoidCallback onTap,
  }) {
    final cardColor = isDark ? const Color(0xFF333333) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF333333);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.openSans(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$newCount New',
                        style: GoogleFonts.openSans(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Orange dot indicator
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColorSchemes.primaryDarkYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(M3Icons.arrowOutward, size: 24, color: textColor),
          ],
        ),
      ),
    );
  }
}
