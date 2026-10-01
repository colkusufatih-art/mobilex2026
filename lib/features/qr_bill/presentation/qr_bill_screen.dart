import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/icons/m3_icons.dart';
import '../../../../ui/components/inputs/app_input_field.dart';
import '../../../../ui/components/inputs/dropdown_form_field.dart';
import '../../../../ui/components/inputs/amount_field.dart';
import '../../../../ui/components/bottom_sheets/recipient_account_sheet.dart';
import '../../../../ui/components/bottom_sheets/address_selection_sheet.dart';
import '../../../../ui/components/bottom_sheets/currency_selection_sheet.dart';
import '../../../../ui/components/bottom_sheets/country_selection_sheet.dart';
import '../../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../../ui/components/buttons/app_filled_button.dart';
import '../services/qr_bill_pdf_service.dart';

import 'package:printing/printing.dart';

/// QR-Bill Screen
///
/// Figma frame: QR-Bill (129:7728)
/// Screen for creating QR-Bills with form inputs
class QrBillScreen extends StatefulWidget {
  const QrBillScreen({super.key});

  @override
  State<QrBillScreen> createState() => _QrBillScreenState();
}

class _QrBillScreenState extends State<QrBillScreen> {
  // Form controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Selected values
  String _selectedCurrency = 'CHF';
  String _selectedCountry = 'Switzerland';
  String _selectedRecipientAccount =
      'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nEUR 4\'323.30';
  String _selectedAddress = 'Römerstrasse 36C, 5400 Baden (CH)';

  @override
  void dispose() {
    _amountController.dispose();
    _additionalInfoController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _addressLine2Controller.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(isDark),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // Recipient Account Dropdown
                    DropdownFormField(
                      label: 'Recipient Account',
                      value: _selectedRecipientAccount,
                      isDark: isDark,
                      onTap: () {
                        _showRecipientAccountSheet(context, isDark);
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Address Dropdown
                    DropdownFormField(
                      label: 'Address',
                      value: _selectedAddress,
                      isDark: isDark,
                      onTap: () {
                        _showAddressSelectionSheet(context);
                      },
                    ),

                    const SizedBox(height: 32),

                    // Amount Section
                    _buildSectionTitle('Amount', isDark),

                    const SizedBox(height: AppSpacing.md),

                    // Currency Dropdown
                    AppInputField(
                      label: 'Currency',
                      value: _selectedCurrency,
                      state: InputFieldState.filled,
                      isDropdown: true,
                      isDark: isDark,
                      onTap: () {
                        _showCurrencySelectionSheet(context);
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Amount Input
                    AmountField(
                      label: 'Amount',
                      hintText: 'Amount',
                      controller: _amountController,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Additional Information Input
                    AppInputField(
                      label: 'Additional information',
                      hintText: 'Additional information',
                      controller: _additionalInfoController,
                      state: InputFieldState.defaultValue,
                      isDark: isDark,
                      showFloatingLabel: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 32),

                    // Payable by (optional) Section
                    _buildSectionTitle('Payable by (optional)', isDark),

                    const SizedBox(height: AppSpacing.md),

                    // Name Input
                    AppInputField(
                      label: 'Name',
                      hintText: 'Name',
                      controller: _nameController,
                      state: InputFieldState.defaultValue,
                      isDark: isDark,
                      showFloatingLabel: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Address Input
                    AppInputField(
                      label: 'Address',
                      hintText: 'Address',
                      controller: _addressController,
                      state: InputFieldState.defaultValue,
                      isDark: isDark,
                      showFloatingLabel: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Address Line 2 Input
                    AppInputField(
                      label: 'Address Line 2',
                      hintText: 'Address Line 2',
                      controller: _addressLine2Controller,
                      state: InputFieldState.defaultValue,
                      isDark: isDark,
                      showFloatingLabel: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Post Code Input
                    AppInputField(
                      label: 'Post code',
                      hintText: 'Post code',
                      controller: _postCodeController,
                      state: InputFieldState.defaultValue,
                      isDark: isDark,
                      showFloatingLabel: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // City Input
                    AppInputField(
                      label: 'City',
                      hintText: 'City',
                      controller: _cityController,
                      state: InputFieldState.defaultValue,
                      isDark: isDark,
                      showFloatingLabel: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Country Dropdown
                    AppInputField(
                      label: 'Country',
                      value: _selectedCountry,
                      state: InputFieldState.filled,
                      isDropdown: true,
                      isDark: isDark,
                      onTap: () {
                        _showCountrySelectionSheet(context);
                      },
                    ),

                    const SizedBox(height: 32),

                    // Generate QR-Bill Button
                    AppFilledButton(
                      text: 'Generate QR-Bill',
                      icon: M3Icons.qrCode,
                      onPressed: _generateQrBill,
                    ),

                    const SizedBox(height: 56), // Bottom padding
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const AppBottomNavigation(activeRoute: '/payments'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          M3Icons.arrowBack,
          color: isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
        ),
        onPressed: () => context.go('/account-detail'),
      ),
      title: Text(
        'QR-Bill',
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColorSchemes.getDividerColor(isDark),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColorSchemes.getTextColor(isDark),
        height: 1.5,
      ),
    );
  }

  void _showRecipientAccountSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RecipientAccountSheet(
          selectedAccount: _selectedRecipientAccount,
          onAccountSelected: (account) {
            setState(() {
              _selectedRecipientAccount = account;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showAddressSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddressSelectionSheet(
          selectedAddress: _selectedAddress,
          onAddressSelected: (address) {
            setState(() {
              _selectedAddress = address;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showCurrencySelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CurrencySelectionSheet(
          selectedCurrency: _selectedCurrency,
          onCurrencySelected: (currency) {
            setState(() {
              _selectedCurrency = currency;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showCountrySelectionSheet(BuildContext context) {
    showModalBottomSheet(
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

  Future<void> _generateQrBill() async {
    final data = QrBillPdfData(
      recipientAccount: _selectedRecipientAccount,
      recipientAddress: _selectedAddress,
      currency: _selectedCurrency,
      amount: _amountController.text.trim().isEmpty
          ? '0.00'
          : _amountController.text.trim(),
      additionalInformation: _additionalInfoController.text.trim(),
      payerName: _nameController.text.trim(),
      payerAddress: _composePayerAddress(),
      payerPostCode: _postCodeController.text.trim(),
      payerCity: _cityController.text.trim(),
      payerCountry: _selectedCountry,
    );

    try {
      final pdfBytes = await QrBillPdfService.generatePdf(data);
      await Printing.layoutPdf(
        name: 'qr-bill.pdf',
        onLayout: (_) async => pdfBytes,
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      debugPrint('QR-Bill generation failed: $error');
      debugPrint(stackTrace.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate QR-Bill: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _composePayerAddress() {
    final lines = <String>[];
    final primaryAddress = _addressController.text.trim();
    final secondaryAddress = _addressLine2Controller.text.trim();

    if (primaryAddress.isNotEmpty) {
      lines.add(primaryAddress);
    }
    if (secondaryAddress.isNotEmpty) {
      lines.add(secondaryAddress);
    }

    return lines.join('\n');
  }
}
