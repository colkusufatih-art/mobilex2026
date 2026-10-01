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
import '../../../ui/components/bottom_sheets/country_selection_sheet.dart';

/// Edit Address Screen
///
/// Screen for editing user address information
class EditAddressScreen extends StatefulWidget {
  final String initialStreet;
  final String initialPostcode;
  final String initialCity;
  final String initialCountry;
  final Function(String street, String addressLine2, String postcode, String city, String country) onSave;

  const EditAddressScreen({
    super.key,
    required this.initialStreet,
    required this.initialPostcode,
    required this.initialCity,
    required this.initialCountry,
    required this.onSave,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController _addressController;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _postcodeController;
  late TextEditingController _cityController;
  late String _selectedCountry;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialStreet);
    _addressLine2Controller = TextEditingController(text: '');
    _postcodeController = TextEditingController(text: widget.initialPostcode);
    _cityController = TextEditingController(text: widget.initialCity);
    _selectedCountry = widget.initialCountry;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _addressLine2Controller.dispose();
    _postcodeController.dispose();
    _cityController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Input Fields
                      AppInputField(
                        label: 'Address',
                        controller: _addressController,
                        state: InputFieldState.filled,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        label: 'Address line 2',
                        hintText: 'Address line 2',
                        controller: _addressLine2Controller,
                        state: InputFieldState.defaultValue,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        label: 'Postcode',
                        controller: _postcodeController,
                        state: InputFieldState.filled,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        label: 'City',
                        controller: _cityController,
                        state: InputFieldState.filled,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        label: 'Country',
                        value: _selectedCountry,
                        state: InputFieldState.filled,
                        isDropdown: true,
                        showFloatingLabel: false,
                        isDark: isDark,
                        trailingIcon: M3Icons.keyboardArrowDown,
                        onTap: () => _showCountrySheet(isDark),
                      ),

                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),

              // Save Button
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  return AnimatedPadding(
                    padding: EdgeInsets.only(
                      bottom: bottomInset > 0 ? bottomInset + 16 : 56,
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                    ),
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    child: AppFilledButton(
                      text: 'Save',
                      onPressed: _handleSave,
                    ),
                  );
                },
              ),

              // Bottom Navigation
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final isKeyboardVisible = bottomInset > 0;
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

    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              const Spacer(),
              Text(
                'Address',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.pop(),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    M3Icons.close,
                    color: textColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: isDark
              ? AppColorSchemes.darkCardBackground
              : AppColorSchemes.greysLightGrey,
        ),
      ],
    );
  }

  void _handleSave() {
    widget.onSave(
      _addressController.text.trim(),
      _addressLine2Controller.text.trim(),
      _postcodeController.text.trim(),
      _cityController.text.trim(),
      _selectedCountry,
    );
    // Return result to previous screen
    context.pop({
      'street': _addressController.text.trim(),
      'postcode': _postcodeController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _selectedCountry,
    });
  }

  void _showCountrySheet(bool isDark) {
    showModalBottomSheet<String>(
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
}

