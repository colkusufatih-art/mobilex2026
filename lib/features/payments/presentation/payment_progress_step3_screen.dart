import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/inputs/app_input_field.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/recipient_account_sheet.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/country_selection_sheet.dart';
import '../domain/payment_draft.dart';

class PaymentProgressStep3Screen extends StatefulWidget {
  final PaymentDraft draft;
  const PaymentProgressStep3Screen({super.key, required this.draft});

  @override
  State<PaymentProgressStep3Screen> createState() =>
      _PaymentProgressStep3ScreenState();
}

class _PaymentProgressStep3ScreenState
    extends State<PaymentProgressStep3Screen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedAccount =
      'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nCHF 4’323.30';
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _standingExecutionsController =
      TextEditingController();
  DateTime _executionDate = DateTime.now();
  String _debitNote = 'Standard';
  String _confidential = 'No';
  String _urgency = 'High';
  bool _isInstantPayment = false;
  bool _ultimateDebtorEnabled = false;
  final TextEditingController _ultimateNameController = TextEditingController();
  final TextEditingController _ultimateAddressController =
      TextEditingController();
  final TextEditingController _ultimateHouseController =
      TextEditingController();
  final TextEditingController _ultimatePostCodeController =
      TextEditingController();
  final TextEditingController _ultimateCityController = TextEditingController();
  String _ultimateCountry = 'Switzerland';
  bool _isStandingOrderEnabled = false;
  String _standingRepeat = 'Monthly';
  String _standingDay = 'Specific day';
  String _standingHoliday = 'Before the holiday';
  DateTime _standingFirstExecution = DateTime.now();
  String _standingValidity = 'Until revoked';
  String _standingExecutions = '';
  DateTime _standingLastExecution = DateTime.now();

  @override
  void initState() {
    super.initState();
    final draft = widget.draft;
    _selectedAccount = draft.selectedAccount;
    _referenceController.text = draft.yourReference;
    _executionDate = draft.executionDate;
    _debitNote = draft.debitNote;
    _confidential = draft.confidential;
    _urgency = draft.urgency;
    _isInstantPayment = draft.instantPayment;
    _ultimateDebtorEnabled = draft.ultimateDebtorEnabled;
    _ultimateNameController.text = draft.ultimateDebtorName;
    _ultimateAddressController.text = draft.ultimateDebtorAddress;
    _ultimateHouseController.text = draft.ultimateDebtorHouseNumber;
    _ultimatePostCodeController.text = draft.ultimateDebtorPostCode;
    _ultimateCityController.text = draft.ultimateDebtorCity;
    _ultimateCountry = draft.ultimateDebtorCountry.isNotEmpty
        ? draft.ultimateDebtorCountry
        : 'Switzerland';
    _isStandingOrderEnabled = draft.standingOrderEnabled;
    _standingRepeat = draft.standingRepeat;
    _standingDay = draft.standingDay;
    _standingHoliday = draft.standingHoliday;
    _standingFirstExecution = draft.firstExecutionDate;
    if (_standingDay == 'End of the month') {
      _standingFirstExecution = _lastDayOfMonth(_executionDate);
    }
    _standingValidity = draft.validity;
    _standingExecutions = draft.numberOfExecutions;
    _standingExecutionsController.text = draft.numberOfExecutions;
    _standingLastExecution = draft.lastExecutionDate;
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _standingExecutionsController.dispose();
    _ultimateNameController.dispose();
    _ultimateAddressController.dispose();
    _ultimateHouseController.dispose();
    _ultimatePostCodeController.dispose();
    _ultimateCityController.dispose();
    _scrollController.dispose();
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
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      _buildAccountSelector(isDark),
                      const SizedBox(height: AppSpacing.sm),
                      AppInputField(
                        label: 'Personal note',
                        hintText: 'Personal note',
                        controller: _referenceController,
                        state: InputFieldState.defaultValue,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppInputField(
                        label: 'Execution date',
                        value: DateFormat('dd.MM.yyyy').format(_executionDate),
                        state: InputFieldState.filled,
                        isDropdown: true,
                        isDark: isDark,
                        showFloatingLabel: false,
                        onTap: () => _pickDate(
                          title: 'Execution date',
                          initialDate: _executionDate,
                          onSelected: (date) {
                            setState(() {
                              _executionDate = date;
                              if (_standingDay == 'End of the month') {
                                _standingFirstExecution =
                                    _lastDayOfMonth(_executionDate);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDropdownField(
                        label: 'Debit note',
                        value: _debitNote,
                        options: const ['Standard', 'Single display'],
                        isDark: isDark,
                        onSelected: (value) {
                          setState(() {
                            _debitNote = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDropdownField(
                        label: 'Confidental',
                        value: _confidential,
                        options: const ['Yes', 'No'],
                        isDark: isDark,
                        onSelected: (value) {
                          setState(() {
                            _confidential = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSwitchRow(
                        label: 'Ultimate Debtor',
                        value: _ultimateDebtorEnabled,
                        isDark: isDark,
                        onChanged: (value) {
                          setState(() {
                            _ultimateDebtorEnabled = value;
                          });
                        },
                      ),
                      if (_ultimateDebtorEnabled) ...[
                        const SizedBox(height: AppSpacing.sm),
                        _buildUltimateDebtorFields(isDark),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      _buildSwitchRow(
                        label: 'Instant Payment',
                        value: _isInstantPayment,
                        isDark: isDark,
                        onChanged: (value) {
                          setState(() {
                            _isInstantPayment = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildStandingOrderToggle(isDark),
                      if (_isStandingOrderEnabled) ...[
                        const SizedBox(height: AppSpacing.sm),
                        _buildDropdownField(
                          label: 'Periodicity',
                          value: _standingRepeat,
                          options: const [
                            'Daily',
                            'Weekly',
                            'Every two weeks',
                            'Monthly',
                            'Every two months',
                            'Quarterly',
                            'Every four months',
                            'Biannually',
                            'Annually',
                          ],
                          isDark: isDark,
                          onSelected: (value) {
                            setState(() {
                              _standingRepeat = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'End of the month',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColorSchemes.getTextColor(isDark),
                              ),
                            ),
                            Switch(
                              value: _standingDay == 'End of the month',
                              activeTrackColor:
                                  AppColorSchemes.primaryDarkYellow,
                              activeThumbColor: AppColorSchemes.greysWhite,
                              inactiveTrackColor:
                                  AppColorSchemes.greysLightGrey,
                              inactiveThumbColor: AppColorSchemes.greysMidGrey,
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    _standingDay = 'End of the month';
                                    _standingFirstExecution =
                                        _lastDayOfMonth(_executionDate);
                                  } else {
                                    _standingDay = 'Specific day';
                                    _standingFirstExecution = _executionDate;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildDropdownField(
                          label: 'Holiday',
                          value: _standingHoliday,
                          options: const [
                            'Before the holiday',
                            'After the holiday',
                          ],
                          isDark: isDark,
                          onSelected: (value) {
                            setState(() {
                              _standingHoliday = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppInputField(
                          label: 'First execution',
                          value: DateFormat('dd.MM.yyyy')
                              .format(_standingFirstExecution),
                          state: InputFieldState.filled,
                          isDropdown: true,
                          isDark: isDark,
                          showFloatingLabel: false,
                          trailingIcon: Icons.calendar_today,
                          trailingIconColor: _standingDay == 'End of the month'
                              ? AppColorSchemes.greysMidGrey
                              : AppColorSchemes.getTextColor(isDark),
                          labelColorOverride: _standingDay == 'End of the month'
                              ? AppColorSchemes.greysMidGrey
                              : null,
                          onTap: _standingDay == 'End of the month'
                              ? null
                              : () => _pickDate(
                                    title: 'First execution',
                                    initialDate: _standingFirstExecution,
                                    onSelected: (date) {
                                      setState(() {
                                        _standingFirstExecution = date;
                                      });
                                    },
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildDropdownField(
                          label: 'Validity',
                          value: _standingValidity,
                          options: const [
                            'Until revoked',
                            'Last execution date',
                            'Number of executions',
                          ],
                          isDark: isDark,
                          onSelected: (value) {
                            setState(() {
                              _standingValidity = value;
                              if (value == 'Number of executions') {
                                _standingExecutionsController.text =
                                    _standingExecutions;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (_standingValidity == 'Number of executions')
                          AppInputField(
                            label: 'Number of executions',
                            hintText: 'Number of executions',
                            controller: _standingExecutionsController,
                            isDark: isDark,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            showFloatingLabel: false,
                            onChanged: (value) {
                              setState(() {
                                _standingExecutions = value;
                              });
                            },
                          )
                        else if (_standingValidity == 'Last execution date')
                          AppInputField(
                            label: 'Last execution',
                            value: DateFormat('dd.MM.yyyy')
                                .format(_standingLastExecution),
                            state: InputFieldState.filled,
                            isDropdown: true,
                            isDark: isDark,
                            showFloatingLabel: false,
                            trailingIcon: Icons.calendar_today,
                            trailingIconColor:
                                AppColorSchemes.getTextColor(isDark),
                            onTap: () => _pickDate(
                              title: 'Last execution',
                              initialDate: _standingLastExecution,
                              onSelected: (date) {
                                setState(() {
                                  _standingLastExecution = date;
                                });
                              },
                            ),
                          ),
                      ],
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
                          selectedAccount: _selectedAccount,
                          yourReference: _referenceController.text,
                          executionDate: _executionDate,
                          debitNote: _debitNote,
                          confidential: _confidential,
                          urgency: _urgency,
                          instantPayment: _isInstantPayment,
                          ultimateDebtorEnabled: _ultimateDebtorEnabled,
                          ultimateDebtorName: _ultimateNameController.text,
                          ultimateDebtorAddress:
                              _ultimateAddressController.text,
                          ultimateDebtorHouseNumber:
                              _ultimateHouseController.text,
                          ultimateDebtorPostCode:
                              _ultimatePostCodeController.text,
                          ultimateDebtorCity: _ultimateCityController.text,
                          ultimateDebtorCountry: _ultimateCountry,
                          standingOrderEnabled: _isStandingOrderEnabled,
                          standingRepeat: _standingRepeat,
                          standingDay: _standingDay,
                          standingHoliday: _standingHoliday,
                          firstExecutionDate: _standingFirstExecution,
                          validity: _standingValidity,
                          numberOfExecutions:
                              _standingExecutionsController.text,
                          lastExecutionDate: _standingLastExecution,
                        );
                        context.push(
                          '/payments/confirm-payment',
                          extra: updatedDraft,
                        );
                      },
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final isKeyboardVisible =
                      MediaQuery.of(context).viewInsets.bottom > 0;
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

  Widget _buildAccountSelector(bool isDark) {
    return AppInputField(
      label: 'Recipient Account',
      value: _selectedAccount,
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      showFloatingLabel: false,
      onTap: () => _showAccountSheet(isDark),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required bool isDark,
    required ValueChanged<String> onSelected,
  }) {
    return AppInputField(
      label: label,
      value: value,
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      showFloatingLabel: false,
      onTap: () => _showSelectionSheet(
        title: label,
        options: options,
        selected: value,
        onSelected: onSelected,
      ),
    );
  }

  Widget _buildStandingOrderToggle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Standing Order',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColorSchemes.getTextColor(isDark),
              ),
            ),
          ),
          Switch(
            value: _isStandingOrderEnabled,
            activeTrackColor: AppColorSchemes.primaryDarkYellow,
            activeThumbColor: AppColorSchemes.greysWhite,
            inactiveTrackColor: AppColorSchemes.greysLightGrey,
            inactiveThumbColor: AppColorSchemes.greysMidGrey,
            onChanged: (value) {
              setState(() {
                _isStandingOrderEnabled = value;
              });
              if (value) {
                _scrollToStandingOrderSection();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColorSchemes.getTextColor(isDark),
              ),
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppColorSchemes.primaryDarkYellow,
            activeThumbColor: AppColorSchemes.greysWhite,
            inactiveTrackColor: AppColorSchemes.greysLightGrey,
            inactiveThumbColor: AppColorSchemes.greysMidGrey,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildUltimateDebtorFields(bool isDark) {
    return Column(
      children: [
        AppInputField(
          label: 'Name',
          hintText: 'Name',
          controller: _ultimateNameController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Address',
          hintText: 'Address',
          controller: _ultimateAddressController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'House number',
          hintText: 'House number',
          controller: _ultimateHouseController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Post code',
          hintText: 'Post code',
          controller: _ultimatePostCodeController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'City',
          hintText: 'City',
          controller: _ultimateCityController,
          state: InputFieldState.defaultValue,
          showFloatingLabel: false,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField(
          label: 'Country',
          value: _ultimateCountry,
          state: InputFieldState.filled,
          isDropdown: true,
          isDark: isDark,
          showFloatingLabel: false,
          onTap: () => _showUltimateCountrySheet(isDark),
        ),
      ],
    );
  }

  Future<void> _showAccountSheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RecipientAccountSheet(
          selectedAccount: _selectedAccount,
          onAccountSelected: (account) {
            setState(() {
              _selectedAccount = account;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _showUltimateCountrySheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CountrySelectionSheet(
          selectedCountry: _ultimateCountry,
          onCountrySelected: (country) {
            setState(() {
              _ultimateCountry = country;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _showSelectionSheet({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SimpleSelectionSheet(
        title: title,
        options: options,
        selectedOption: selected,
        onOptionSelected: onSelected,
      ),
    );
  }

  DateTime _lastDayOfMonth(DateTime date) {
    final beginningNextMonth = DateTime(date.year, date.month + 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1));
  }

  void _scrollToStandingOrderSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final targetOffset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickDate({
    required String title,
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final baseTheme = Theme.of(context);
    final isDark = baseTheme.brightness == Brightness.dark;
    final textColor = AppColorSchemes.getTextColor(isDark);
    final subtleTextColor = AppColorSchemes.getTextLightColor(isDark);
    final accentColor = AppColorSchemes.primaryDarkYellow;
    final backgroundColor =
        isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final headerBackground =
        isDark ? AppColorSchemes.darkBackground : Colors.white;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      helpText: title,
      builder: (context, child) {
        final ColorScheme colorScheme =
            isDark ? AppColorSchemes.dark : AppColorSchemes.light;

        Color? resolveDayForeground(Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return subtleTextColor.withValues(alpha: 0.4);
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textColor;
        }

        Color? resolveDayBackground(Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return Colors.transparent;
        }

        Color? resolveYearForeground(Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textColor;
        }

        Color? resolveYearBackground(Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return Colors.transparent;
        }

        OutlinedBorder? resolveYearShape(Set<WidgetState> states) {
          return const StadiumBorder();
        }

        Color? resolveYearOverlay(Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return accentColor.withValues(alpha: 0.16);
          }
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered)) {
            return accentColor.withValues(alpha: 0.08);
          }
          return Colors.transparent;
        }

        final textColorPrimary = AppColorSchemes.getTextColor(isDark);
        final dialogBackground =
            isDark ? AppColorSchemes.darkCardBackground : Colors.white;

        final themedText = baseTheme.textTheme.copyWith(
          titleMedium: GoogleFonts.openSans(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            height: 1.25,
            color: textColorPrimary,
          ),
          bodyMedium: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0.5,
            color: textColorPrimary,
          ),
        );

        return Theme(
          data: baseTheme.copyWith(
            colorScheme: colorScheme,
            textTheme: themedText,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: textColorPrimary,
                textStyle: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: dialogBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: isDark
                  ? AppColorSchemes.darkCardBackground
                  : const Color(0xFFF9F9F9),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintStyle: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.5,
                color: AppColorSchemes.greysMidGrey,
              ),
              labelStyle: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.33,
                color: accentColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColorSchemes.greysLightGrey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accentColor, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColorSchemes.greysLightGrey, width: 1),
              ),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: accentColor,
              selectionColor: accentColor.withValues(alpha: 0.24),
              selectionHandleColor: accentColor,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: backgroundColor,
              surfaceTintColor: Colors.transparent,
              shadowColor:
                  isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              headerBackgroundColor: headerBackground,
              headerForegroundColor: textColorPrimary,
              headerHeadlineStyle: GoogleFonts.openSans(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                height: 1.25,
                color: textColorPrimary,
              ),
              headerHelpStyle: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                letterSpacing: 0.1,
                color: AppColorSchemes.greysMidGrey,
              ),
              dayStyle: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              dayForegroundColor:
                  WidgetStateProperty.resolveWith(resolveDayForeground),
              dayBackgroundColor:
                  WidgetStateProperty.resolveWith(resolveDayBackground),
              weekdayStyle: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: subtleTextColor,
              ),
              yearStyle: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              yearForegroundColor:
                  WidgetStateProperty.resolveWith(resolveYearForeground),
              yearBackgroundColor:
                  WidgetStateProperty.resolveWith(resolveYearBackground),
              yearShape: WidgetStateProperty.resolveWith(resolveYearShape),
              yearOverlayColor:
                  WidgetStateProperty.resolveWith(resolveYearOverlay),
              todayForegroundColor: WidgetStateProperty.all(accentColor),
              todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
              todayBorder: BorderSide(color: accentColor),
              dayOverlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return accentColor.withValues(alpha: 0.12);
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onSelected(picked);
    }
  }
}

class _SimpleSelectionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const _SimpleSelectionSheet({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const handleColor = AppColorSchemes.greysMidGrey;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorSchemes.darkBackground : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Container(
                width: 35,
                height: 5,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == selectedOption;
                  final backgroundColor = isSelected
                      ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
                      : AppColorSchemes.getCardBackgroundColor(isDark);
                  final textColor = AppColorSchemes.getTextColor(isDark);
                  final checkColor = isDark
                      ? AppColorSchemes.primaryDarkYellow
                      : AppColorSchemes.greysDarkGrey;

                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                      onTap: () {
                        onOptionSelected(option);
                        Navigator.of(context).pop();
                      },
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
                                color: checkColor,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemCount: options.length,
              ),
            ),
          ],
        ),
      ),
    );
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
                  'Payment instructions',
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
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
                ),
                Expanded(
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
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
