import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/inputs/app_input_field.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// New Message Screen
///
/// Screen for composing a new message
class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  String? _selectedRecipient;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<String> _recipients = [
    'CLX Helpline',
    'James Din_Advisor',
    'Peter Schmitt_Advisor',
  ];

  @override
  void initState() {
    super.initState();
    _subjectController.addListener(_onFormChanged);
    _messageController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _subjectController.removeListener(_onFormChanged);
    _messageController.removeListener(_onFormChanged);
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  bool _isSendButtonEnabled() {
    return _selectedRecipient != null &&
        _selectedRecipient!.isNotEmpty &&
        _subjectController.text.trim().isNotEmpty &&
        _messageController.text.trim().isNotEmpty;
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
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          'New Message',
                          style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: AppColorSchemes.getTextColor(isDark),
                            height: 1.25,
                          ),
                        ),
                      ),

                      // To Dropdown
                      _buildRecipientDropdown(context, isDark),

                      const SizedBox(height: 16),

                      const SizedBox(height: 16),

                      // Subject Input Field
                      AppInputField(
                        label: '',
                        hintText: 'Subject',
                        controller: _subjectController,
                        state: InputFieldState.defaultValue,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 16),

                      // Message Input Field (multiline)
                      AppInputField(
                        label: '',
                        hintText: 'Message',
                        controller: _messageController,
                        state: InputFieldState.defaultValue,
                        showFloatingLabel: false,
                        isDark: isDark,
                        maxLines: 4,
                      ),

                      const SizedBox(height: 16),

                      // Attach Documents Field
                      _buildAttachDocumentsField(context, isDark),

                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),

              // Send Button (above keyboard when visible, 56px above bottom navigation when hidden)
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final isKeyboardVisible = bottomInset > 0;
                  final bottomPadding = isKeyboardVisible ? bottomInset + 16 : 56.0;

                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom: bottomPadding,
                    ),
                    child: AppFilledButton(
                      text: 'Send',
                      onPressed: _isSendButtonEnabled()
                          ? () {
                              context.go('/messages/confirmed');
                            }
                          : null,
                    ),
                  );
                },
              ),

              // Bottom Navigation (stays in background when keyboard is visible)
              Builder(
                builder: (context) {
                  final isKeyboardVisible =
                      MediaQuery.of(context).viewInsets.bottom > 0;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isKeyboardVisible ? 0 : 1,
                    child: isKeyboardVisible
                        ? const SizedBox.shrink()
                        : const AppBottomNavigation(activeRoute: '/more'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return AppBar(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          M3Icons.arrowBack,
          color: textColor,
        ),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildRecipientDropdown(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const labelColor = AppColorSchemes.greysMidGrey;
    final bgColor = isDark ? AppColorSchemes.darkCardBackground : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'To',
          style: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: labelColor,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedRecipient,
            decoration: InputDecoration(
              filled: true,
              fillColor: bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            hint: Text(
              'Please select',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: labelColor,
              ),
            ),
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
            items: _recipients.map((String recipient) {
              return DropdownMenuItem<String>(
                value: recipient,
                child: Text(recipient),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedRecipient = value;
              });
            },
            icon: Icon(
              M3Icons.keyboardArrowDown,
              color: textColor,
            ),
            dropdownColor: bgColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAttachDocumentsField(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final bgColor = isDark ? AppColorSchemes.darkCardBackground : Colors.white;

    return Builder(
      builder: (BuildContext fieldContext) {
        return InkWell(
          onTap: () => _showAttachmentMenu(fieldContext, isDark),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.transparent,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Attach documents',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.attach_file,
                  size: 24,
                  color: textColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAttachmentMenu(BuildContext fieldContext, bool isDark) {
    final RenderBox? renderBox = fieldContext.findRenderObject() as RenderBox?;
    final Offset offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final screenWidth = MediaQuery.of(fieldContext).size.width;
    const menuWidth = 265.65; // 231px + 15% (34.65px) = 265.65px
    const menuHeight = 193.0;
    
    // Position menu so right edge is 16px from screen right edge
    // showMenu uses screen coordinates, so we calculate directly
    final menuTop = offset.dy - menuHeight - 8;
    
    showMenu<String>(
      context: fieldContext,
      color: isDark ? AppColorSchemes.darkCardBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      position: RelativeRect.fromLTRB(
        screenWidth - menuWidth - 16 + 95, // Left: screen width - menu width - 16px margin + 95px right (60 + 20 + 10 + 5)
        menuTop + 100, // Top: above attach field + 100px down
        screenWidth - 16 + 95, // Right: 16px from screen edge + 95px right (60 + 20 + 10 + 5)
        menuTop + menuHeight + 100, // Bottom: top + height + 100px down
      ),
      items: [
        _buildMenuItem('Gallery', Icons.image_outlined, fieldContext, isDark, showDivider: true),
        _buildMenuItem('Take a photo', Icons.photo_camera_outlined, fieldContext, isDark, showDivider: true),
        _buildMenuItem('Record video', Icons.video_camera_back_outlined, fieldContext, isDark, showDivider: true),
        _buildMenuItem('Select file', Icons.folder_open_outlined, fieldContext, isDark),
      ],
    ).then((value) {
      if (value != null) {
        // Handle option selection
        print('Selected: $value');
      }
    });
  }

  PopupMenuItem<String> _buildMenuItem(
    String title,
    IconData icon,
    BuildContext context,
    bool isDark,
    {bool showDivider = false}
  ) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final dividerColor = isDark
        ? AppColorSchemes.darkCardBackground
        : AppColorSchemes.greysLightGrey;
    
    return PopupMenuItem<String>(
      value: title,
      height: showDivider ? 45 : 44, // 44px item + 1px divider
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
          if (showDivider)
            Container(
              margin: const EdgeInsets.only(top: 12),
              height: 1,
              color: dividerColor,
            ),
        ],
      ),
    );
  }
}

