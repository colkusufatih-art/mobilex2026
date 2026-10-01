import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/inputs/app_input_field.dart';
import '../../../ui/components/inputs/dropdown_form_field.dart';
import '../../../ui/components/bottom_sheets/recipient_account_sheet.dart';
import '../../../ui/components/bottom_sheets/stock_exchange_selection_sheet.dart';
import '../../../ui/components/inputs/amount_field.dart';

/// Sell Position Detail Screen
///
/// Shows detailed information and form for selling a specific position
class SellPositionDetailScreen extends StatefulWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final String? percentage;
  final bool? isPositive;

  const SellPositionDetailScreen({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.percentage,
    this.isPositive,
  });

  @override
  State<SellPositionDetailScreen> createState() => _SellPositionDetailScreenState();
}

class _SellPositionDetailScreenState extends State<SellPositionDetailScreen> {
  String _selectedStockExchange = 'SIX SWISS EXCHANGE / EUROPE / CHF';
  final TextEditingController _pcsController = TextEditingController();
  String _selectedOrderType = 'Best';
  final TextEditingController _limitChfController = TextEditingController();
  DateTime _validUntilDate = DateTime(2025, 12, 31);
  String _selectedSettlementAccount = 'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nCHF 4\'323.30';

  @override
  void dispose() {
    _pcsController.dispose();
    _limitChfController.dispose();
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
              // Progress Header
              _ProgressHeader(isDark: isDark, title: 'Sell'),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transaction Header
                      _buildTransactionHeader(isDark),

                      const SizedBox(height: 16),

                      // Form Fields
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stock exchange
                            AppInputField(
                              label: 'Stock exchange',
                              value: _selectedStockExchange,
                              state: InputFieldState.filled,
                              isDropdown: true,
                              isDark: isDark,
                              showFloatingLabel: false,
                              trailingIcon: Icons.expand_more,
                              onTap: () => _showStockExchangeSelection(isDark),
                            ),

                            const SizedBox(height: 16),

                            // Pcs. Input (Numbers only)
                            AppInputField(
                              label: '',
                              hintText: 'Pcs.',
                              controller: _pcsController,
                              state: InputFieldState.defaultValue,
                              showFloatingLabel: false,
                              isDark: isDark,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: false,
                                signed: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Denomination Text
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Denomination ',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColorSchemes.getTextColor(isDark),
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '1 Piece',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColorSchemes.getTextColor(isDark),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Order type
                            AppInputField(
                              label: 'Order type',
                              value: _selectedOrderType,
                              state: InputFieldState.filled,
                              isDropdown: true,
                              isDark: isDark,
                              showFloatingLabel: false,
                              trailingIcon: Icons.expand_more,
                              onTap: () => _showOrderTypeSelection(isDark),
                            ),

                            // CHF Limit Input (only shown when Limited is selected)
                            if (_selectedOrderType == 'Limited') ...[
                              const SizedBox(height: 16),
                              AmountField(
                                label: 'CHF',
                                hintText: 'CHF',
                                controller: _limitChfController,
                                isDark: isDark,
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Valid until Date Picker
                            AppInputField(
                              label: 'Valid until',
                              value: DateFormat('dd.MM.yyyy').format(_validUntilDate),
                              state: InputFieldState.filled,
                              isDropdown: true,
                              isDark: isDark,
                              showFloatingLabel: false,
                              trailingIcon: Icons.calendar_today,
                              trailingIconColor: AppColorSchemes.getTextColor(isDark),
                              onTap: () => _pickDate(),
                            ),

                            const SizedBox(height: 16),

                            // Depot Info
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1502 CHF',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColorSchemes.getTextColor(isDark),
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '771534601502',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColorSchemes.getTextColor(isDark),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Settlement account
                            DropdownFormField(
                              label: 'Settlement account',
                              value: _selectedSettlementAccount,
                              isDark: isDark,
                              onTap: () => _showSettlementAccountSelection(isDark),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Next Button (above keyboard when visible)
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Calculate amount from Pcs or use original amount
                          final pcsValue = _pcsController.text.trim();
                          String calculatedAmount = widget.amount;
                          String? pcsDisplayValue;
                          
                          if (pcsValue.isNotEmpty) {
                            // Parse original amount to get price per piece
                            final pricePerPiece = _parseAmount(widget.amount);
                            // Parse Pcs value (remove any formatting)
                            final pcsNumber = _parseNumber(pcsValue);
                            
                            if (pricePerPiece > 0 && pcsNumber > 0) {
                              // Calculate total: Pcs * Price per piece
                              final totalAmount = pcsNumber * pricePerPiece;
                              calculatedAmount = _formatAmount(totalAmount);
                              pcsDisplayValue = pcsValue;
                            }
                          }
                          
                          context.push('/trading/sell-confirm', extra: {
                            'title': widget.title,
                            'subtitle': widget.subtitle ?? 'NESN-T2 | Valor 993886335 ISIN CH9938863350',
                            'amount': calculatedAmount,
                            'pcs': pcsDisplayValue ?? '1',
                            'stockExchange': _selectedStockExchange,
                            'orderType': _selectedOrderType,
                            'validUntil': _validUntilDate,
                            'settlementAccount': _selectedSettlementAccount,
                            'limitChf': _selectedOrderType == 'Limited' ? _limitChfController.text.trim() : null,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorSchemes.greysDarkGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Next',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Bottom Navigation (hidden when keyboard is visible)
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

  Widget _buildTransactionHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 343,
                  child: Text(
                    widget.title,
                    style: GoogleFonts.openSans(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 343,
                  child: Text(
                    widget.subtitle ?? 'NESN-T2 | Valor 993886335 ISIN CH9938863350',
                    style: GoogleFonts.openSans(
                      color: subtitleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 2.19,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Amount and Price Section
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Amount
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _buildAmountWithChfColor(widget.amount, textColor),
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Price 14.10. 2025',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.openSans(
                                color: subtitleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 2.19,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Graph (placeholder)
                      const SizedBox(
                        width: 249,
                        height: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: AppColorSchemes.getDividerColor(isDark),
              height: 1,
              thickness: 1,
            ),
          ),

        ],
      ),
    );
  }

  double _parseAmount(String amount) {
    // Remove "CHF" and parse the number
    String cleaned = amount.replaceAll('CHF', '').trim();
    // Remove apostrophes (thousands separator)
    cleaned = cleaned.replaceAll("'", '');
    // Replace comma with dot for decimal
    cleaned = cleaned.replaceAll(',', '.');
    // Extract only numbers and decimal point
    cleaned = cleaned.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  double _parseNumber(String value) {
    // Remove any formatting (apostrophes, etc.)
    String cleaned = value.replaceAll("'", '').replaceAll(',', '.');
    cleaned = cleaned.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  String _formatAmount(double amount) {
    // Format with 2 decimal places and thousands separator
    String formatted = amount.toStringAsFixed(2);
    List<String> parts = formatted.split('.');
    String beforeDecimal = parts[0];
    String afterDecimal = parts[1];
    
    // Add apostrophes for thousands separators
    if (beforeDecimal.length > 3) {
      String formattedNumber = '';
      int digits = beforeDecimal.length;
      for (int i = 0; i < digits; i++) {
        if (i > 0 && (digits - i) % 3 == 0) {
          formattedNumber += '\'';
        }
        formattedNumber += beforeDecimal[i];
      }
      beforeDecimal = formattedNumber;
    }
    
    return 'CHF $beforeDecimal.$afterDecimal';
  }

  Widget _buildAmountWithChfColor(String amount, Color textColor) {
    final activeColor = AppColorSchemes.primaryDarkYellow; // #FFA814
    
    // Check if amount starts with CHF, EUR, USD, etc.
    if (amount.toUpperCase().startsWith('CHF')) {
      final amountNum = amount.substring(3).trim();
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'CHF ',
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: activeColor,
                height: 1.25,
              ),
            ),
            TextSpan(
              text: amountNum,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: textColor,
                height: 1.25,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.right,
      );
    } else {
      // For other currencies or formats, display as is
      return Text(
        amount,
        textAlign: TextAlign.right,
        style: GoogleFonts.openSans(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.25,
        ),
      );
    }
  }

  Future<void> _showStockExchangeSelection(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StockExchangeSelectionSheet(
          selectedStockExchange: _selectedStockExchange,
          onStockExchangeSelected: (stockExchange) {
            setState(() {
              _selectedStockExchange = stockExchange;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _showOrderTypeSelection(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SimpleSelectionSheet(
        title: 'Order type',
        options: const ['Best', 'Limited'],
        selectedOption: _selectedOrderType,
        onOptionSelected: (value) {
          setState(() {
            _selectedOrderType = value;
            if (value != 'Limited') {
              _limitChfController.clear();
            }
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntilDate,
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
      setState(() {
        _validUntilDate = picked;
      });
    }
  }

  Future<void> _showSettlementAccountSelection(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RecipientAccountSheet(
          selectedAccount: _selectedSettlementAccount,
          onAccountSelected: (account) {
            setState(() {
              _selectedSettlementAccount = account;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final bool isDark;
  final String title;
  const _ProgressHeader({required this.isDark, required this.title});

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
                icon: M3Icons.arrowBack,
                color: textColor,
                onTap: () => context.pop(),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              _HeaderIconButton(
                icon: M3Icons.close,
                color: textColor,
                onTap: () => context.go('/trading'),
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
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  M3Icons.check,
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
