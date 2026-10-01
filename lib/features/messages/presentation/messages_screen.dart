import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/cards/message_card.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// Messages Screen
///
/// Displays a list of messages with the ability to create new messages
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Track read status of messages
  final Map<String, bool> _messageReadStatus = {
    'Your account statements': false,
    'New swiss banking plattform': false,
    'Your Account': false,
  };

  // Track deleted messages
  final Set<String> _deletedMessages = <String>{};

  void _markMessageAsRead(String subject) {
    setState(() {
      _messageReadStatus[subject] = true;
    });
  }

  void _deleteMessage(String subject) {
    setState(() {
      _deletedMessages.add(subject);
    });
  }

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
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Divider
              Divider(
                color: isDark
                    ? AppColorSchemes.darkCardBackground
                    : AppColorSchemes.greysLightGrey,
                height: 1,
                thickness: 1,
              ),

              // Messages List
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      ..._buildMessageList(isDark, context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // New Message Button
              Padding(
                padding: const EdgeInsets.only(
                  top: 42,
                  bottom: 56,
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                ),
                child: AppFilledButton(
                  text: 'New Message',
                  onPressed: () {
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
          // WCAG 2.2: Semantics für Zurück-Button
          Semantics(
            button: true,
            label: 'Zurück',
            child: Tooltip(
              message: 'Zurück',
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.go('/more'),
                child: SizedBox(
                  width: 48, // WCAG 2.5: Minimum Touch Target
                  height: 48,
                  child: Center(
                    child: Icon(
                      M3Icons.arrowBack,
                      color: textColor,
                      size: 24,
                      semanticLabel: 'Zurück',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Messages',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.0,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance the back button width
        ],
      ),
    );
  }

  List<Widget> _buildMessageList(bool isDark, BuildContext context) {
    // Sample message data - messages from "Max Crealogix" are left-aligned
    // Messages from user would be right-aligned
    final messages = [
      {
        'subject': 'Your account statements',
        'message':
            'CREALOGIX is a Swiss-based software company that specializes in digital banking and wealth management solutions...',
        'sender': 'Max Crealogix',
        'dateTime': '01.  January 2025 | 08:40',
        'hasAttachment': true,
        'isLeftAligned': true,
        'isFirstInGroup': true,
      },
      {
        'subject': 'New swiss banking plattform',
        'message':
            'We hope this letter finds you well. We are writing to inform you that your tax documents for the year [Year] are now available...',
        'sender': 'Max Crealogix',
        'dateTime': '01.  January 2025 | 08:40',
        'hasAttachment': true,
        'isLeftAligned': true,
        'isFirstInGroup': false,
        'hasTopLeftRadius': true,
      },
      {
        'subject': 'New swiss banking plattform',
        'message':
            'It is important to review these documents carefully and consult with your tax advisor to ensure you have all the necessary information for your...',
        'sender': '',
        'dateTime': '01.  January 2025 | 08:40',
        'hasAttachment': false,
        'isLeftAligned': false,
        'isFirstInGroup': true,
      },
      {
        'subject': 'Your Account',
        'message':
            'CREALOGIX is a Swiss-based software company that specializes in digital banking and wealth management solutions...',
        'sender': 'Max Crealogix',
        'dateTime': '01.  January 2025 | 08:40',
        'hasAttachment': true,
        'isLeftAligned': true,
        'isFirstInGroup': false,
        'hasTopRightRadius': true,
      },
    ];

    return messages
        .where((message) => !_deletedMessages.contains(message['subject'] as String))
        .map((message) {
      final subject = message['subject'] as String;
      final isLeftAligned = message['isLeftAligned'] as bool;
      final isFirstInGroup = message['isFirstInGroup'] as bool? ?? false;
      final hasTopRightRadius = message['hasTopRightRadius'] as bool? ?? false;
      final hasTopLeftRadius = message['hasTopLeftRadius'] as bool? ?? false;
      final isRead = _messageReadStatus[subject] ?? true; // Default to read for user messages
      
      return Align(
        alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
        child: MessageCard(
          subject: subject,
          message: message['message'] as String,
          sender: message['sender'] as String,
          dateTime: message['dateTime'] as String,
          hasAttachment: message['hasAttachment'] as bool,
          isRead: isRead,
          isLeftAligned: isLeftAligned,
          isFirstInGroup: isFirstInGroup,
          hasTopRightRadius: hasTopRightRadius,
          hasTopLeftRadius: hasTopLeftRadius,
          onTap: () {
            // Mark message as read when tapped
            _markMessageAsRead(subject);
            
            context.push(
              '/messages/detail',
              extra: {
                'subject': subject,
                'message': message['message'] as String,
                'sender': message['sender'] as String,
                'dateTime': message['dateTime'] as String,
                'hasAttachment': message['hasAttachment'] as bool,
                'onDelete': () => _deleteMessage(subject),
              },
            ).then((_) {
              // Refresh state when returning from detail screen
              setState(() {});
            });
          },
        ),
      );
    }).toList();
  }
}

