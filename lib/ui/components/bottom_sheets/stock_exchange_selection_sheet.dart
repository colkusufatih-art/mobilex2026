import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/icons/m3_icons.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';

class StockExchangeSelectionSheet extends StatelessWidget {
  final String selectedStockExchange;
  final ValueChanged<String> onStockExchangeSelected;

  const StockExchangeSelectionSheet({
    super.key,
    required this.selectedStockExchange,
    required this.onStockExchangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const stockExchanges = _stockExchanges;

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
          _buildHandle(),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Stock exchange',
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
                final stockExchange = stockExchanges[index];
                final isSelected = stockExchange.name == selectedStockExchange;

                return _buildStockExchangeCard(stockExchange, isSelected, isDark);
              },
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemCount: stockExchanges.length,
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

  Widget _buildStockExchangeCard(StockExchangeData stockExchange, bool isSelected, bool isDark) {
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
        onTap: () => onStockExchangeSelected(stockExchange.name),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  stockExchange.name,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.5,
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

class StockExchangeData {
  final String name;

  const StockExchangeData({
    required this.name,
  });
}

const List<StockExchangeData> _stockExchanges = [
  StockExchangeData(
    name: 'SIX SWISS EXCHANGE / EUROPE / CHF',
  ),
  StockExchangeData(
    name: 'FRANKFURTER WERTPAPIERBOERSE / EUR',
  ),
  StockExchangeData(
    name: 'BOERSE DUESSELDORF / EUR',
  ),
  StockExchangeData(
    name: 'BAYERISCHE BOERSE / EUR',
  ),
  StockExchangeData(
    name: 'BADEN-WUERTTEMBERGISCHE WERTPAPIERBOERSE / EUR',
  ),
  StockExchangeData(
    name: 'HANSEATISCHE WERTPAPIERBOERSTE / EUR',
  ),
  StockExchangeData(
    name: 'XETRA / EUR',
  ),
  StockExchangeData(
    name: 'EURONEXT PARIS / EUR',
  ),
];

