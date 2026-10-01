import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';

/// Depot Selection Bottom Sheet
///
/// Bottom sheet for selecting a depot in Trading Buy/Sell screens
class DepotSelectionSheet extends StatelessWidget {
  final String selectedDepot;
  final Function(String) onDepotSelected;
  final bool hideCurrentAccount;
  /// When true (e.g. depot 1518 EUR selected), show all CHF amounts as EUR.
  final bool useEurForDisplay;

  const DepotSelectionSheet({
    super.key,
    required this.selectedDepot,
    required this.onDepotSelected,
    this.hideCurrentAccount = false,
    this.useEurForDisplay = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          // Handle
          _buildHandle(isDark),

          // Header
          _buildHeader(isDark),

          // Depot Cards
          Flexible(
            child: _buildDepotList(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
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

  Widget _buildHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Reto Haldner',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepotList(bool isDark) {
    final depots = [
      DepotData(
        depotName: '1518 EUR',
        accountNumber: '771534621502',
        balance: 'EUR 4\'323.30',
        secondaryBalance: 'CHF 32\'918.30',
        displayValue: '1518 EUR\n771534621502',
        isSelected: selectedDepot.contains('1518 EUR'),
      ),
      if (!hideCurrentAccount)
        DepotData(
          depotName: 'Current Account',
          accountNumber: 'CH51 0076 5345 1001 9150 2',
          balance: 'CHF 23\'082.00',
          secondaryBalance: 'CHF 32\'918.30',
          displayValue: 'Current Account\nCH51 0076 5345 1001 9150 2',
          isSelected: selectedDepot.contains('Current Account'),
        ),
      DepotData(
        depotName: '1501 CHF',
        accountNumber: '771534621599',
        balance: 'CHF 19\'706\'006.25',
        secondaryBalance: 'CHF 32\'918.30',
        displayValue: '1501 CHF\n771534621599',
        isSelected: selectedDepot.contains('1501 CHF'),
      ),
      DepotData(
        depotName: '1507 CHF',
        accountNumber: '771534621506',
        balance: 'CHF 23\'495.94',
        secondaryBalance: 'CHF 32\'918.30',
        displayValue: '1507 CHF\n771534621506',
        isSelected: selectedDepot.contains('1507 CHF'),
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: 56,
      ),
      itemCount: depots.length,
      itemBuilder: (context, index) {
        return _buildDepotCard(context, depots[index], isDark);
      },
    );
  }

  Widget _buildDepotCard(BuildContext context, DepotData depot, bool isDark) {
    final cardColor = depot.isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : AppColorSchemes.getCardBackgroundColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);
    final checkColor = isDark
        ? AppColorSchemes.primaryDarkYellow
        : AppColorSchemes.greysDarkGrey;

    return Container(
      height: 126,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: () {
          onDepotSelected(depot.displayValue);
          Navigator.of(context).pop();
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Depot Name and Check icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      depot.depotName,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (depot.isSelected)
                    Icon(
                      M3Icons.check,
                      size: 24,
                      color: checkColor,
                    ),
                ],
              ),
              // Account Number (closer to title to prevent overflow)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  depot.accountNumber,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColorSchemes.greysMidGrey,
                  ),
                ),
              ),
              // 2px spacing between Account Number and Amount
              const SizedBox(height: 2),
              // Spacer to push Amount to bottom
              const Spacer(),
              // Amount row (right-aligned, 12px from bottom)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  useEurForDisplay && depot.balance.contains('CHF')
                      ? depot.balance.replaceAll('CHF', 'EUR')
                      : depot.balance,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DepotData {
  final String depotName;
  final String accountNumber;
  final String balance;
  final String secondaryBalance;
  final String displayValue;
  final bool isSelected;

  DepotData({
    required this.depotName,
    required this.accountNumber,
    required this.balance,
    required this.secondaryBalance,
    required this.displayValue,
    required this.isSelected,
  });
}

