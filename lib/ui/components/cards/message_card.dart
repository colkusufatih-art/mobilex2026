import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';

/// Message Card Component
///
/// Displays a single message with subject, content, sender, date, and optional attachment
/// Designed for chat-like message flow with left/right alignment
class MessageCard extends StatelessWidget {
  final String subject;
  final String message;
  final String sender;
  final String dateTime;
  final bool hasAttachment;
  final bool isRead;
  final bool isLeftAligned;
  final bool isFirstInGroup;
  final bool hasTopRightRadius;
  final bool hasTopLeftRadius;
  final VoidCallback? onTap;

  const MessageCard({
    super.key,
    required this.subject,
    required this.message,
    required this.sender,
    required this.dateTime,
    this.hasAttachment = false,
    this.isRead = true,
    this.isLeftAligned = true,
    this.isFirstInGroup = false,
    this.hasTopRightRadius = false,
    this.hasTopLeftRadius = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isRead
        ? (isDark ? AppColorSchemes.darkCardBackground : const Color(0xFFFAFAFA))
        : (isDark ? AppColorSchemes.darkCardBackground : Colors.white);
    final textColor = AppColorSchemes.getTextColor(isDark);
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate card width based on screen width and margins
    final cardWidth = isLeftAligned
        ? screenWidth - 16 - 28 // 16px left, 28px right for left-aligned
        : screenWidth - 28 - 16; // 28px left, 16px right for right-aligned

    // Border radius logic
    BorderRadius borderRadius;
    if (hasTopLeftRadius && isLeftAligned) {
      // Special case: top-left corner rounded
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    } else if (hasTopRightRadius && isLeftAligned) {
      // Special case: all corners rounded except bottom-left
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.zero,
        bottomRight: Radius.circular(8),
      );
    } else if (isFirstInGroup && isLeftAligned) {
      // First card in group, left-aligned: all corners except bottom-right
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.zero,
      );
    } else if (isFirstInGroup && !isLeftAligned) {
      // First card in group, right-aligned: all corners except bottom-right
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.zero,
      );
    } else if (isLeftAligned) {
      // Regular left-aligned: only right side rounded
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    } else {
      // Regular right-aligned: only left side rounded
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        margin: EdgeInsets.only(
          bottom: 16,
          left: isLeftAligned ? 16 : 28,
          right: isLeftAligned ? 28 : 16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Row with Bullet
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    subject,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1.0,
                    ),
                  ),
                ),
                if (!isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColorSchemes.primaryDarkYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Message Content
            Text(
              message,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.375, // 22px line height / 16px font size
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Sender and Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sender (left-aligned)
                if (sender.isNotEmpty)
                  Text(
                    sender,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                      height: 1.83, // 22px line height / 12px font size
                    ),
                  )
                else
                  const SizedBox.shrink(),
                // Attachment, Date, Time (right-aligned)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasAttachment) ...[
                      Icon(
                        Icons.attach_file,
                        size: 12,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      sender.isNotEmpty ? '| $dateTime' : dateTime,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                        height: 1.83,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

