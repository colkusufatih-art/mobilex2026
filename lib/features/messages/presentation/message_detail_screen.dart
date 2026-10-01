import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// Message Detail Screen
///
/// Displays detailed view of a single message
class MessageDetailScreen extends StatelessWidget {
  final String subject;
  final String message;
  final String sender;
  final String dateTime;
  final bool hasAttachment;
  final VoidCallback? onDelete;

  const MessageDetailScreen({
    super.key,
    required this.subject,
    required this.message,
    required this.sender,
    required this.dateTime,
    this.hasAttachment = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (Subject)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          subject,
                          style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: AppColorSchemes.getTextColor(isDark),
                            height: 1.25,
                          ),
                        ),
                      ),

                      // Message Content
                      Text(
                        _getFullMessage(),
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColorSchemes.getTextColor(isDark),
                          height: 1.375,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Attachment Section
                      if (hasAttachment) _buildAttachmentSection(isDark),

                      const SizedBox(height: 32),

                      // Delete Message Option
                      _buildDeleteMessageOption(context, isDark),

                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),

              // Reply Button (fix positioned, 56px above bottom navigation)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 56),
                child: AppFilledButton(
                  text: 'Reply',
                  icon: Icons.reply,
                  onPressed: () {
                    // Handle reply action
                    context.push('/messages/new');
                  },
                ),
              ),

              // Bottom Navigation
              const AppBottomNavigation(activeRoute: '/more'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      height: 56,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.pop(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                M3Icons.arrowBack,
                color: textColor,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40), // Balance the back button width
        ],
      ),
    );
  }

  Widget _buildAttachmentSection(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const labelColor = AppColorSchemes.greysMidGrey;
    
    // Sample attachment data
    final attachments = [
      {
        'name': 'Bank statement january 2025',
        'type': 'PDF',
        'size': '3.5 MB',
      },
      {
        'name': 'Personal information',
        'type': 'PDF',
        'size': '1.5 MB',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attachment Header
        Text(
          'Attachment',
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        // Attachment List
        ...attachments.map((attachment) {
          return _buildAttachmentItem(
            attachment['name'] as String,
            attachment['type'] as String,
            attachment['size'] as String,
            isDark,
            textColor,
            labelColor,
          );
        }),
        const SizedBox(height: 24),
        // Divider
        Divider(
          color: isDark
              ? AppColorSchemes.darkCardBackground
              : AppColorSchemes.greysLightGrey,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildAttachmentItem(
    String name,
    String type,
    String size,
    bool isDark,
    Color textColor,
    Color labelColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            Icons.description,
            size: 24,
            color: textColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$type | $size',
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteMessageOption(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return InkWell(
      onTap: () {
        _showDeleteMessageBottomSheet(context, isDark);
      },
      child: Row(
        children: [
          Icon(
            Icons.close,
            size: 20,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            'Delete Message',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteMessageBottomSheet(BuildContext context, bool isDark) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DeleteMessageBottomSheet(
        isDark: isDark,
        onDelete: () {
          Navigator.of(context).pop(); // Close bottom sheet
          // Call onDelete callback if provided
          onDelete?.call();
          context.pop(); // Go back to messages
        },
        onCancel: () {
          Navigator.of(context).pop(); // Close bottom sheet
        },
      ),
    );
  }

  String _getFullMessage() {
    // If message ends with "...", append the full text
    if (message.endsWith('...')) {
      return '$message\n\nThe following documents have been prepared and are ready for your review:\n\nYou can access these documents through our online banking portal by following these steps:\n\nIf you prefer to receive physical copies, please contact our customer service team at. We will be happy to mail the documents to your address on file.\n\nIt is important to review these documents carefully and consult with your tax advisor to ensure you have all the necessary information for your tax filings. If you notice any discrepancies or have any questions, please do not hesitate to reach out to us.\n\nThank you for choosing [Bank\'s Name]. We appreciate your trust and look forward to serving you in the future.\n\nSincerely,\n\nYour Advisor';
    }
    return message;
  }
}

/// Delete Message Bottom Sheet
///
/// Bottom sheet for confirming message deletion
/// Based on Cancel Order Bottom Sheet structure
class _DeleteMessageBottomSheet extends StatelessWidget {
  final bool isDark;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const _DeleteMessageBottomSheet({
    required this.isDark,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 35,
            height: 5,
            decoration: BoxDecoration(
              color: AppColorSchemes.greysMidGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (H1)
                Text(
                  'Delete Message',
                  style: GoogleFonts.openSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  'Are you sure you want to delete this message?',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 60),

                // Yes Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorSchemes.greysDarkGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColorSchemes.darkCardBackground
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

