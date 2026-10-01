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
import '../domain/payment_draft.dart';

class ForeignPaymentStep2Screen extends StatefulWidget {
  final PaymentDraft draft;
  const ForeignPaymentStep2Screen({super.key, required this.draft});

  @override
  State<ForeignPaymentStep2Screen> createState() =>
      _ForeignPaymentStep2ScreenState();
}

class _ForeignPaymentStep2ScreenState
    extends State<ForeignPaymentStep2Screen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedAccount =
      'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nCHF 4\'323.30';
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _standingExecutionsController =
      TextEditingController();
  DateTime _executionDate = DateTime.now();
  String _debitNote = 'Standard';
  String _confidential = 'No';
  String _urgency = 'High';
  String _fees = 'Shared fees';
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
    _fees = draft.fees;
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
                        trailingIcon: Icons.calendar_today,
                        trailingIconColor: AppColorSchemes.getTextColor(isDark),
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
                        label: 'Fees',
                        value: _fees,
                        options: const [
                          'Shared fees',
                          'At the expense of the client',
                          'At the expense of the recipient',
                        ],
                        isDark: isDark,
                        onSelected: (value) {
                          setState(() {
                            _fees = value;
                          });
                        },
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
                      const SizedBox(height: AppSpacing.sm),
                      _buildDropdownField(
                        label: 'Urgency',
                        value: _urgency,
                        options: const ['Standard', 'High'],
                        isDark: isDark,
                        onSelected: (value) {
                          setState(() {
                            _urgency = value;
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
                          fees: _fees,
                          standingOrderEnabled: _isStandingOrderEnabled,
                          standingRepeat: _standingRepeat,
                          standingDay: _standingDay,
                          standingHoliday: _standingHoliday,
                          firstExecutionDate: _standingFirstExecution,
                          validity: _standingValidity,
                          numberOfExecutions: _standingExecutions,
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

  Future<void> _pickDate({
    required String title,
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColorSchemes.primaryDarkYellow,
              onPrimary: Colors.white,
              surface: isDark
                  ? AppColorSchemes.darkCardBackground
                  : Colors.white,
              onSurface: AppColorSchemes.getTextColor(isDark),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
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
                  color: AppColorSchemes.getTextColor(isDarkMode),
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
                final isSelected = option == selectedOption;
                return _buildOptionTile(option, isSelected, isDarkMode);
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
        onTap: () => onOptionSelected(option),
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

