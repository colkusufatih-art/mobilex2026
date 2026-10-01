import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';

/// Account Selection Bottom Sheet
///
/// Figma component: BP-Switch (23:2229)
/// Bottom sheet with account selection cards
class AccountSelectionSheet extends StatelessWidget {
  final String selectedAccount;
  final Function(String) onAccountSelected;

  const AccountSelectionSheet({
    super.key,
    required this.selectedAccount,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
        children: [
          // Handle
          _buildHandle(isDark),

          // Header
          _buildHeader(context, isDark),

          // Account Cards
          Expanded(
            child: _buildAccountList(context, isDark),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Total',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const Spacer(),
          Text(
            context.withAppCurrency('CHF 2\'428\'561.60'),
            style: GoogleFonts.openSans(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountList(BuildContext context, bool isDark) {
    final accounts = [
      AccountData(
        name: 'Reto Haldner',
        balance: 'CHF 21\'454.30',
        isSelected: selectedAccount == 'Reto Haldner',
      ),
      AccountData(
        name: 'Mareike Haldner',
        balance: 'CHF 299\'126.30',
        isSelected: selectedAccount == 'Mareike Haldner',
      ),
      AccountData(
        name: 'Vanessa Haldner',
        balance: 'CHF 454.30',
        isSelected: selectedAccount == 'Vanessa Haldner',
      ),
      AccountData(
        name: 'Sportverein Wetzikon',
        balance: 'CHF 2\'532\'454.30',
        isSelected: selectedAccount == 'Sportverein Wetzikon',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return _buildAccountCard(context, accounts[index], isDark);
      },
    );
  }

  Widget _buildAccountCard(BuildContext context, AccountData account, bool isDark) {
    final cardColor = account.isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : AppColorSchemes.getCardBackgroundColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);
    final checkColor = isDark
        ? AppColorSchemes.primaryDarkYellow
        : AppColorSchemes.greysDarkGrey;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: () => onAccountSelected(account.name),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.withAppCurrency(account.balance),
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Check icon
              if (account.isSelected)
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

class AccountData {
  final String name;
  final String balance;
  final bool isSelected;

  AccountData({
    required this.name,
    required this.balance,
    required this.isSelected,
  });
}
