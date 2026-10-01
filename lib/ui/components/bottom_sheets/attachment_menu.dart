import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';

/// Attachment Menu
///
/// Menu for selecting attachment options
class AttachmentMenu extends StatelessWidget {
  final Function(String option)? onOptionSelected;

  const AttachmentMenu({
    super.key,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final textColor = AppColorSchemes.getTextColor(isDark);
    final dividerColor = isDark
        ? AppColorSchemes.darkCardBackground
        : AppColorSchemes.greysLightGrey;

    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            context: context,
            title: 'Gallery',
            icon: Icons.image,
            isDark: isDark,
            textColor: textColor,
            onTap: () {
              Navigator.of(context).pop();
              onOptionSelected?.call('Gallery');
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
          _buildMenuItem(
            context: context,
            title: 'Take a photo',
            icon: Icons.photo_camera,
            isDark: isDark,
            textColor: textColor,
            onTap: () {
              Navigator.of(context).pop();
              onOptionSelected?.call('Take a photo');
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
          _buildMenuItem(
            context: context,
            title: 'Record video',
            icon: Icons.videocam,
            isDark: isDark,
            textColor: textColor,
            onTap: () {
              Navigator.of(context).pop();
              onOptionSelected?.call('Record video');
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
          _buildMenuItem(
            context: context,
            title: 'Select file',
            icon: Icons.folder_open,
            isDark: isDark,
            textColor: textColor,
            onTap: () {
              Navigator.of(context).pop();
              onOptionSelected?.call('Select file');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDark,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 24,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}

