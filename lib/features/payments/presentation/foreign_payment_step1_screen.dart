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

class ForeignPaymentStep1Screen extends StatefulWidget {
  final PaymentDraft draft;
  ForeignPaymentStep1Screen({super.key, PaymentDraft? draft})
      : draft = draft ?? PaymentDraft();

  @override
  State<ForeignPaymentStep1Screen> createState() =>
      _ForeignPaymentStep1ScreenState();
}

class _ForeignPaymentStep1ScreenState
    extends State<ForeignPaymentStep1Screen> {
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _swiftBicController = TextEditingController();
  final TextEditingController _bankClearingNumberController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  String _bankIdentification = 'Swift/BIC';
  String _selectedCountry = 'Switzerland';
  String _selectedBankCountry = 'United Kingdom';
  String? _bankName;
  String? _bankLocation;

  @override
  void initState() {
    super.initState();
    final draft = widget.draft;
    _ibanController.text = draft.iban;
    _nameController.text = draft.recipientName;
    _addressLineController.text = draft.addressLine1;
    _addressLine2Controller.text = draft.addressLine2;
    _postCodeController.text = draft.postCode;
    _cityController.text = draft.city;
    _selectedCountry = draft.country.isNotEmpty ? draft.country : 'Switzerland';
    _referenceController.text = draft.recipientReference;
    
    _ibanController.addListener(_onIbanChanged);
    _checkIbanAndFillBankInfo();
  }

  void _onIbanChanged() {
    _checkIbanAndFillBankInfo();
  }

  void _checkIbanAndFillBankInfo() {
    final iban = _ibanController.text.replaceAll(' ', '').toUpperCase();
    if (iban.length >= 4) {
      final countryCode = iban.substring(0, 2);
      final bankInfo = _getBankInfoFromIban(iban, countryCode);
      
      if (bankInfo != null) {
        setState(() {
          _swiftBicController.text = bankInfo['swiftBic'] ?? '';
          _bankName = bankInfo['bankName'];
          _bankLocation = bankInfo['bankLocation'];
        });
      } else {
        setState(() {
          if (_swiftBicController.text.isNotEmpty && 
              !_swiftBicController.text.contains('CITIGB2LXXX')) {
            // Don't clear if user manually entered something
          } else {
            _swiftBicController.text = '';
          }
          _bankName = null;
          _bankLocation = null;
        });
      }
    } else {
      setState(() {
        _swiftBicController.text = '';
        _bankName = null;
        _bankLocation = null;
      });
    }
  }

  Map<String, String>? _getBankInfoFromIban(String iban, String countryCode) {
    // Normalize IBAN (remove spaces, convert to uppercase)
    final normalizedIban = iban.replaceAll(' ', '').toUpperCase();
    
    // IBAN Bank Database - Maps IBAN patterns to bank information
    // Format: IBAN prefix pattern -> {swiftBic, bankName, bankLocation}
    final ibanBankDatabase = {
      // United Kingdom - Citi Bank
      'UK65': {
        'swiftBic': 'CITIGB2LXXX',
        'bankName': 'London Citi Bank',
        'bankLocation': 'London, Vereinigtes Königreich',
      },
      // Germany - Deutsche Bank
      'DE89': {
        'swiftBic': 'DEUTDEFFXXX',
        'bankName': 'Deutsche Bank',
        'bankLocation': 'Frankfurt, Deutschland',
      },
      'DE37': {
        'swiftBic': 'DEUTDEFFXXX',
        'bankName': 'Deutsche Bank',
        'bankLocation': 'Frankfurt, Deutschland',
      },
      // United States - Bank of America (using international format)
      'US64': {
        'swiftBic': 'BOFAUS3NXXX',
        'bankName': 'Bank of America',
        'bankLocation': 'New York, United States',
      },
      'US12': {
        'swiftBic': 'CHASUS33XXX',
        'bankName': 'JPMorgan Chase Bank',
        'bankLocation': 'New York, United States',
      },
      // Norway - DNB Bank
      'NO93': {
        'swiftBic': 'DNBANOKKXXX',
        'bankName': 'DNB Bank',
        'bankLocation': 'Oslo, Norwegen',
      },
      'NO11': {
        'swiftBic': 'DNBANOKKXXX',
        'bankName': 'DNB Bank',
        'bankLocation': 'Oslo, Norwegen',
      },
    };
    
    // Check if IBAN matches any pattern in database
    // Try exact match first (first 4 characters)
    if (normalizedIban.length >= 4) {
      final prefix = normalizedIban.substring(0, 4);
      if (ibanBankDatabase.containsKey(prefix)) {
        return ibanBankDatabase[prefix];
      }
    }
    
    // If no exact match, try country-based lookup with common patterns
    // This allows for more flexible matching based on country code
    final countryBasedPatterns = {
      'UK': {
        'swiftBic': 'CITIGB2LXXX',
        'bankName': 'London Citi Bank',
        'bankLocation': 'London, Vereinigtes Königreich',
      },
      'DE': {
        'swiftBic': 'DEUTDEFFXXX',
        'bankName': 'Deutsche Bank',
        'bankLocation': 'Frankfurt, Deutschland',
      },
      'US': {
        'swiftBic': 'BOFAUS3NXXX',
        'bankName': 'Bank of America',
        'bankLocation': 'New York, United States',
      },
      'NO': {
        'swiftBic': 'DNBANOKKXXX',
        'bankName': 'DNB Bank',
        'bankLocation': 'Oslo, Norwegen',
      },
    };
    
    // Fallback to country-based lookup if no specific pattern matches
    if (countryBasedPatterns.containsKey(countryCode)) {
      return countryBasedPatterns[countryCode];
    }
    
    return null;
  }

  @override
  void dispose() {
    _ibanController.removeListener(_onIbanChanged);
    _ibanController.dispose();
    _swiftBicController.dispose();
    _bankClearingNumberController.dispose();
    _nameController.dispose();
    _addressLineController.dispose();
    _addressLine2Controller.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    _referenceController.dispose();
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
                          addressLine1: _addressLineController.text,
                          addressLine2: _addressLine2Controller.text,
                          postCode: _postCodeController.text,
                          city: _cityController.text,
                          country: _selectedCountry,
                          recipientReference: _referenceController.text,
                        );
                        context.push(
                          '/payments/foreign-payment-step-2',
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
        _buildBankIdentificationDropdown(isDark),
        const SizedBox(height: AppSpacing.sm),
        if (_bankIdentification == 'Swift/BIC') ...[
          AppInputField(
            label: 'Swift/BIC',
            hintText: 'Swift/BIC',
            controller: _swiftBicController,
            state: InputFieldState.defaultValue,
            showFloatingLabel: false,
            isDark: isDark,
          ),
          if (_bankName != null && _bankLocation != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildBankInfoDisplay(isDark),
          ],
        ]
        else ...[
          _buildBankCountryDropdown(isDark),
          const SizedBox(height: AppSpacing.sm),
          AppInputField(
            label: 'Bank clearing number',
            hintText: 'Bank clearing number',
            controller: _bankClearingNumberController,
            state: InputFieldState.defaultValue,
            showFloatingLabel: false,
            isDark: isDark,
          ),
        ],
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
          label: 'Address line',
          hintText: 'Address line',
          controller: _addressLineController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Address line 2',
          hintText: 'Address line 2',
          controller: _addressLine2Controller,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Street',
          hintText: 'Street',
          controller: _streetController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'House number',
          hintText: 'House number',
          controller: _houseNumberController,
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
      ],
    );
  }

  Widget _buildBankIdentificationDropdown(bool isDark) {
    return AppInputField(
      label: 'Bank identification',
      value: _bankIdentification,
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      onTap: () => _showBankIdentificationSheet(isDark),
    );
  }

  Widget _buildBankCountryDropdown(bool isDark) {
    return AppInputField(
      label: 'Country of the Bank',
      value: _selectedBankCountry,
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      onTap: () => _showBankCountrySelectionSheet(isDark),
    );
  }

  Widget _buildBankInfoDisplay(bool isDark) {
    if (_bankName == null || _bankLocation == null) {
      return const SizedBox.shrink();
    }

    final textColor = AppColorSchemes.getTextColor(isDark);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _bankName!,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _bankLocation!,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBankIdentificationSheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SimpleSelectionSheet(
        title: 'Bank identification',
        options: const ['Swift/BIC', 'Bank Code'],
        selectedValue: _bankIdentification,
        onSelected: (value) {
          setState(() {
            _bankIdentification = value;
          });
          Navigator.of(context).pop();
        },
        isDark: isDark,
      ),
    );
  }

  Future<void> _showBankCountrySelectionSheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CountrySelectionSheet(
          selectedCountry: _selectedBankCountry,
          onCountrySelected: (country) {
            setState(() {
              _selectedBankCountry = country;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
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
      // Re-check bank info after formatting
      _checkIbanAndFillBankInfo();
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
    return Material(
      color: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back,
                color: textColor,
                onTap: () => context.go('/payments'),
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
                  child: Container(
                    height: 1,
                    color: AppColorSchemes.primaryDarkYellow,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: isDark
                        ? AppColorSchemes.darkCardBackground
                        : const Color(0xFFDADADA),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: isDark
                        ? AppColorSchemes.darkCardBackground
                        : const Color(0xFFDADADA),
                  ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}

class _SimpleSelectionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final bool isDark;

  const _SimpleSelectionSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 35,
            height: 5,
            decoration: BoxDecoration(
              color: AppColorSchemes.greysMidGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option == selectedValue;
                return _buildOptionTile(option, isSelected, isDark);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String option, bool isSelected, bool isDark) {
    final backgroundColor = isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : Colors.transparent;
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onSelected(option),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 24,
                  color: isDark
                      ? AppColorSchemes.primaryDarkYellow
                      : AppColorSchemes.greysDarkGrey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

