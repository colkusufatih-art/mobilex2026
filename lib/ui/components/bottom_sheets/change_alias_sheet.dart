import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';

/// Change Alias Bottom Sheet
///
/// Figma component: Change Alias (117:6114)
/// Bottom sheet for editing account alias
class ChangeAliasSheet extends StatefulWidget {
  final String currentAlias;
  final Function(String) onSave;

  const ChangeAliasSheet({
    super.key,
    required this.currentAlias,
    required this.onSave,
  });

  @override
  State<ChangeAliasSheet> createState() => _ChangeAliasSheetState();
}

class _ChangeAliasSheetState extends State<ChangeAliasSheet> {
  late TextEditingController _aliasController;

  @override
  void initState() {
    super.initState();
    _aliasController = TextEditingController(text: widget.currentAlias);
  }

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
        children: [
          // Handle
          _buildHandle(isDark),

          // Title
          _buildTitle(isDark),

          const SizedBox(height: AppSpacing.md),

          // Input Field
          _buildInputField(isDark),

          const Spacer(),

          // Save Button
          _buildSaveButton(isDark),

          // 56px padding below Save Button
          const SizedBox(height: 56),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 35,
      height: 5,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysMidGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Change Alias',
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final inputBgColor =
        isDark ? AppColorSchemes.darkCardBackground : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label
              Text(
                'Alias',
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1.5,
                ),
              ),
              // Text Field
              Expanded(
                child: TextField(
                  controller: _aliasController,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                    height: 1.5,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    final buttonBgColor =
        isDark ? AppColorSchemes.darkCardBackground : const Color(0xFF333333);
    const buttonTextColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            widget.onSave(_aliasController.text);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBgColor,
            foregroundColor: buttonTextColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: buttonTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
