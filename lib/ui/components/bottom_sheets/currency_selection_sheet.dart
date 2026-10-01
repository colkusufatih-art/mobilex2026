import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/icons/m3_icons.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';

class CurrencySelectionSheet extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencySelected;

  const CurrencySelectionSheet({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const currencies = _currencies;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
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
          _buildHandle(),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Currency',
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
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: 56,
              ),
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = currency == selectedCurrency;

                return _buildCurrencyCard(currency, isSelected, isDark);
              },
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemCount: currencies.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 35,
      height: 5,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysMidGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildCurrencyCard(String currency, bool isSelected, bool isDark) {
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
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => onCurrencySelected(currency),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  currency,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  M3Icons.check,
                  size: 24,
                  color: checkColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> _currencies = [
  'CHF',
  'EUR',
  'USD',
  'GBP',
  'JPY',
  'AUD',
  'CAD',
  'CZK',
  'DKK',
  'HKD',
  'HUF',
  'NOK',
  'NZD',
  'PLN',
  'SEK',
  'SGD',
  'THB',
  'ZAR',
];
