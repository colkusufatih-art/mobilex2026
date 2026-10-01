import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/inputs/app_input_field.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/country_selection_sheet.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import '../domain/payment_draft.dart';

class QrPaymentStep1Screen extends StatefulWidget {
  final PaymentDraft draft;
  QrPaymentStep1Screen({super.key, PaymentDraft? draft})
      : draft = draft ?? PaymentDraft();

  @override
  State<QrPaymentStep1Screen> createState() => _QrPaymentStep1ScreenState();
}

class _QrPaymentStep1ScreenState extends State<QrPaymentStep1Screen> {
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _beneficiaryReferenceController =
      TextEditingController();

  String _selectedCountry = 'Switzerland';

  @override
  void initState() {
    super.initState();
    final draft = widget.draft;
    _ibanController.text = draft.iban;
    _nameController.text = draft.recipientName;
    _addressController.text = draft.addressLine1;
    _addressLine2Controller.text = draft.addressLine2;
    _postCodeController.text = draft.postCode;
    _cityController.text = draft.city;
    _selectedCountry = draft.country.isNotEmpty ? draft.country : 'Switzerland';
    _referenceController.text = draft.recipientReference;
    _beneficiaryReferenceController.text = draft.purposeOfPayment;
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _addressLine2Controller.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    _referenceController.dispose();
    _beneficiaryReferenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColorSchemes.darkBackground : AppColorSchemes.lightBackground;

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
              _ProgressHeader(isDark: isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      _buildInputFields(isDark),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final isKeyboardVisible = bottomInset > 0;
                  final bottomPadding =
                      isKeyboardVisible ? bottomInset + 16 : 56.0;

                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom: bottomPadding,
                    ),
                    child: AppFilledButton(
                      text: 'Next',
                      onPressed: () {
                        final updatedDraft = widget.draft.copyWith(
                          iban: _ibanController.text,
                          recipientName: _nameController.text,
                          addressLine1: _addressController.text,
                          addressLine2: _addressLine2Controller.text,
                          postCode: _postCodeController.text,
                          city: _cityController.text,
                          country: _selectedCountry,
                          recipientReference: _referenceController.text,
                          purposeOfPayment: _beneficiaryReferenceController.text,
                        );
                        context.push(
                          '/payments/payment-progress-step-2',
                          extra: updatedDraft,
                        );
                      },
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final isKeyboardVisible = bottomInset > 0;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isKeyboardVisible ? 0 : 1,
                    child: isKeyboardVisible
                        ? const SizedBox.shrink()
                        : const AppBottomNavigation(activeRoute: '/payments'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputField(
          label: 'IBAN',
          hintText: 'IBAN',
          controller: _ibanController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
          onFocusChanged: _handleIbanFocusChanged,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Name',
          hintText: 'Name',
          controller: _nameController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Street',
          hintText: 'Street',
          controller: _addressController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'House number',
          hintText: 'House number',
          controller: _addressLine2Controller,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Post code',
          hintText: 'Post code',
          controller: _postCodeController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'City',
          hintText: 'City',
          controller: _cityController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Country',
          value: _selectedCountry,
          state: InputFieldState.filled,
          isDropdown: true,
          isDark: isDark,
          onTap: () => _showCountrySelectionSheet(isDark),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Reference',
          hintText: 'Reference',
          controller: _referenceController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Beneficiary reference',
          hintText: 'Beneficiary reference',
          controller: _beneficiaryReferenceController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
      ],
    );
  }

  Future<void> _showCountrySelectionSheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CountrySelectionSheet(
          selectedCountry: _selectedCountry,
          onCountrySelected: (country) {
            setState(() {
              _selectedCountry = country;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _handleIbanFocusChanged(bool hasFocus) {
    if (hasFocus) {
      return;
    }
    final formatted = _formatIban(_ibanController.text);
    if (_ibanController.text != formatted) {
      setState(() {
        _ibanController.text = formatted;
        _ibanController.selection =
            TextSelection.collapsed(offset: formatted.length);
      });
    }
  }

  String _formatIban(String value) {
    // ignore: deprecated_member_use
    final sanitized = value
        // ignore: deprecated_member_use
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();
    if (sanitized.isEmpty) {
      return '';
    }
    final buffer = StringBuffer();
    for (var i = 0; i < sanitized.length; i += 4) {
      final end = (i + 4 <= sanitized.length) ? i + 4 : sanitized.length;
      buffer.write(sanitized.substring(i, end));
      if (end != sanitized.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }
}

class _ProgressHeader extends StatelessWidget {
  final bool isDark;
  const _ProgressHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final backgroundColor =
        isDark ? AppColorSchemes.darkBackground : AppColorSchemes.lightBackground;
    final inactiveDividerColor =
        isDark ? AppColorSchemes.greysDarkGrey : AppColorSchemes.greysLightGrey;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back,
                color: textColor,
                onTap: () => context.pop(),
              ),
              Expanded(
                child: Text(
                  'Recipient',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              _HeaderIconButton(
                icon: Icons.close,
                color: textColor,
                onTap: () => context.go('/payments'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
                ),
                Expanded(
                  child: Container(color: inactiveDividerColor),
                ),
                Expanded(
                  child: Container(color: inactiveDividerColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }
}

