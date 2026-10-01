import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/inputs/amount_field.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/currency_selection_sheet.dart';
import '../domain/payment_draft.dart';

class PaymentProgressStep2Screen extends StatefulWidget {
  final PaymentDraft draft;
  const PaymentProgressStep2Screen({super.key, required this.draft});

  @override
  State<PaymentProgressStep2Screen> createState() =>
      _PaymentProgressStep2ScreenState();
}

class _PaymentProgressStep2ScreenState
    extends State<PaymentProgressStep2Screen> {
  final TextEditingController _amountController = TextEditingController();
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.draft.amount;
    _selectedCurrency = widget.draft.currency;
  }

  @override
  void dispose() {
    _amountController.dispose();
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
                          amount: _amountController.text,
                          currency: _selectedCurrency,
                        );
                        context.push(
                          '/payments/payment-progress-step-3',
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

  Widget _buildCurrencySelector(bool isDark) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCurrencySelectionSheet(isDark),
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                isDark ? AppColorSchemes.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCurrency,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColorSchemes.getTextColor(isDark),
              ),
            ],
          ),
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
                  'Amount',
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

