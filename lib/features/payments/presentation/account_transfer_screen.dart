import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/inputs/app_input_field.dart';
import 'package:mobilex2025/ui/components/inputs/amount_field.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/recipient_account_sheet.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/currency_selection_sheet.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/debit_note_selection_sheet.dart';
import '../domain/account_transfer_draft.dart';

class AccountTransferScreen extends StatefulWidget {
  final AccountTransferDraft? draft;
  const AccountTransferScreen({super.key, this.draft});

  @override
  State<AccountTransferScreen> createState() => _AccountTransferScreenState();
}

class _AccountTransferScreenState extends State<AccountTransferScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _personalNoteController = TextEditingController();
  final TextEditingController _standingExecutionsController =
      TextEditingController();

  late String _fromAccount;
  late String _toAccount;
  late String _selectedCurrency;
  late String _selectedDebitNote;
  late DateTime _executionDate;
  late bool _isStandingOrder;
  late String _standingRepeat;
  late String _standingDay;
  late String _standingHoliday;
  late DateTime _standingFirstExecution;
  late String _standingValidity;
  late String _standingExecutions;
  late DateTime _standingLastExecution;

  @override
  void initState() {
    super.initState();
    final draft = widget.draft ?? AccountTransferDraft();
    _fromAccount = draft.fromAccount;
    _toAccount = draft.toAccount;
    _selectedCurrency = draft.currency;
    _selectedDebitNote = draft.debitNote;
    _executionDate = draft.executionDate;
    _isStandingOrder = draft.standingOrderEnabled;
    _standingRepeat = draft.standingRepeat;
    _standingDay = draft.standingDay;
    _standingHoliday = draft.standingHoliday;
    _standingFirstExecution = draft.standingFirstExecution;
    _standingValidity = draft.standingValidity;
    _standingExecutions = draft.standingExecutions;
    _standingLastExecution = draft.standingLastExecution;
    _amountController.text = draft.amount;
    _referenceController.text = draft.reference;
    _purposeController.text = draft.purposeOfPayment;
    _personalNoteController.text = draft.personalNote;
    _standingExecutionsController.text = draft.standingExecutions;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    _purposeController.dispose();
    _personalNoteController.dispose();
    _standingExecutionsController.dispose();
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
                      // From Section
                      const SizedBox(height: 24),
                      _buildSectionTitle('From', isDark),
                      const SizedBox(height: AppSpacing.sm),
                      _buildAccountSelector(
                        label: 'Debit account',
                        value: _fromAccount,
                        isDark: isDark,
                        onTap: () => _showAccountSelectionSheet(
                          isDark,
                          (account) {
                            setState(() {
                              _fromAccount = account;
                            });
                          },
                          _fromAccount,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildCurrencySelector(isDark),
                      const SizedBox(height: AppSpacing.sm),
                      AmountField(
                        label: 'Amount',
                        hintText: 'Amount',
                        controller: _amountController,
                        isDark: isDark,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // To Section
                      const SizedBox(height: 32),
                      _buildSectionTitle('To', isDark),
                      const SizedBox(height: AppSpacing.sm),
                      _buildAccountSelector(
                        label: 'Credit account',
                        value: _toAccount,
                        isDark: isDark,
                        onTap: () => _showAccountSelectionSheet(
                          isDark,
                          (account) {
                            setState(() {
                              _toAccount = account;
                            });
                          },
                          _toAccount,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDatePicker(isDark),
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
                        label: 'Purpose of payment',
                        hintText: 'Purpose of payment',
                        controller: _purposeController,
                        state: InputFieldState.defaultValue,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDebitNoteSelector(isDark),
                      const SizedBox(height: AppSpacing.sm),
                      AppInputField(
                        label: 'Personal note',
                        hintText: 'Personal note',
                        controller: _personalNoteController,
                        state: InputFieldState.defaultValue,
                        showFloatingLabel: false,
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildStandingOrderSwitch(isDark),
                      if (_isStandingOrder) ...[
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
                              activeTrackColor: AppColorSchemes.primaryDarkYellow,
                              activeThumbColor: AppColorSchemes.greysWhite,
                              inactiveTrackColor: AppColorSchemes.greysLightGrey,
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
                        final updatedDraft = AccountTransferDraft(
                          fromAccount: _fromAccount,
                          toAccount: _toAccount,
                          currency: _selectedCurrency,
                          amount: _amountController.text,
                          executionDate: _executionDate,
                          reference: _referenceController.text,
                          purposeOfPayment: _purposeController.text,
                          debitNote: _selectedDebitNote,
                          personalNote: _personalNoteController.text,
                          standingOrderEnabled: _isStandingOrder,
                          standingRepeat: _standingRepeat,
                          standingDay: _standingDay,
                          standingHoliday: _standingHoliday,
                          standingFirstExecution: _standingFirstExecution,
                          standingValidity: _standingValidity,
                          standingExecutions: _standingExecutions,
                          standingLastExecution: _standingLastExecution,
                        );
                        context.go(
                          '/payments/confirm-account-transfer',
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

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColorSchemes.getTextColor(isDark),
        letterSpacing: 0.14,
      ),
    );
  }

  Widget _buildAccountSelector({
    required String label,
    required String value,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return AppInputField(
      label: label,
      value: value.isEmpty ? null : value,
      hintText: value.isEmpty ? label : null,
      state: value.isEmpty ? InputFieldState.defaultValue : InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      onTap: onTap,
      trailingIcon: Icons.expand_more,
    );
  }

  Widget _buildCurrencySelector(bool isDark) {
    return AppInputField(
      label: 'Currency',
      value: _selectedCurrency,
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      onTap: () => _showCurrencySelectionSheet(isDark),
      trailingIcon: Icons.expand_more,
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return AppInputField(
      label: 'Execution date',
      value: DateFormat('dd.MM.yyyy').format(_executionDate),
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      showFloatingLabel: false,
      trailingIcon: Icons.calendar_today,
      trailingIconColor: AppColorSchemes.getTextColor(isDark),
      onTap: () => _pickDate(
        title: 'Execution date',
        initialDate: _executionDate,
        onSelected: (date) {
          setState(() {
            _executionDate = date;
          });
        },
      ),
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

  Widget _buildDebitNoteSelector(bool isDark) {
    return AppInputField(
      label: 'Debit note',
      value: _selectedDebitNote,
      state: InputFieldState.filled,
      isDropdown: true,
      isDark: isDark,
      showFloatingLabel: false,
      trailingIcon: Icons.expand_more,
      onTap: () => _showDebitNoteSelectionSheet(isDark),
    );
  }

  Widget _buildStandingOrderSwitch(bool isDark) {
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
            value: _isStandingOrder,
            activeTrackColor: AppColorSchemes.primaryDarkYellow,
            activeThumbColor: AppColorSchemes.greysWhite,
            inactiveTrackColor: AppColorSchemes.greysLightGrey,
            inactiveThumbColor: AppColorSchemes.greysMidGrey,
            onChanged: (value) {
              setState(() {
                _isStandingOrder = value;
                if (value) {
                  _scrollToStandingOrderSection();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAccountSelectionSheet(
    bool isDark,
    Function(String) onAccountSelected,
    String selectedAccount,
  ) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RecipientAccountSheet(
          selectedAccount: selectedAccount,
          onAccountSelected: (account) {
            onAccountSelected(account);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _showCurrencySelectionSheet(bool isDark) async {
    await showModalBottomSheet<String>(
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

  Future<void> _showDebitNoteSelectionSheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DebitNoteSelectionSheet(
          selectedDebitNote: _selectedDebitNote,
          onDebitNoteSelected: (debitNote) {
            setState(() {
              _selectedDebitNote = debitNote;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _pickDate({
    required String title,
    required DateTime initialDate,
    required Function(DateTime) onSelected,
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
                onTap: () => context.go('/payments'),
              ),
              Expanded(
                child: Text(
                  'Account Transfer',
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

