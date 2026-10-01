import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';

/// Recipient Account Selection Bottom Sheet
///
/// Bottom sheet for selecting a recipient account in QR-Bill creation
/// Groups accounts by account holder
class RecipientAccountSheet extends StatelessWidget {
  final String selectedAccount;
  final Function(String) onAccountSelected;

  const RecipientAccountSheet({
    super.key,
    required this.selectedAccount,
    required this.onAccountSelected,
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

          // Header with Account Holder Name
          _buildHeader(isDark),

          // Account Cards grouped by Account Holder
          Flexible(
            child: _buildAccountList(isDark),
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

  Widget _buildAccountList(bool isDark) {
    // Group accounts by account holder
    final accountHolders = [
      AccountHolderData(
        name: 'Reto Haldner',
        accounts: [
          DepotAccountData(
            depotName: '1518 EUR',
            accountNumber: 'CH85 9558 4848 4932 3332 2',
            balance: 'EUR 4\'323.30',
            fullValue:
                'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nEUR 4\'323.30',
            isSelected: selectedAccount.contains('1518 EUR') &&
                selectedAccount.contains('Reto Haldner'),
          ),
          DepotAccountData(
            depotName: 'Current Account',
            accountNumber: 'CH51 0076 5345 1001 9150 2',
            balance: 'CHF 23\'082.00',
            fullValue:
                'Reto Haldner\nCurrent Account\nCH51 0076 5345 1001 9150 2\nCHF 23\'082.00',
            isSelected: selectedAccount.contains('Current Account') &&
                selectedAccount.contains('Reto Haldner'),
          ),
          DepotAccountData(
            depotName: '1501 CHF',
            accountNumber: 'CH13 0076 1001 5345 9150 1',
            balance: 'CHF 19\'706\'006.25',
            fullValue:
                'Reto Haldner\n1501 CHF\nCH13 0076 1001 5345 9150 1\nCHF 19\'706\'006.25',
            isSelected: selectedAccount.contains('1501 CHF') &&
                selectedAccount.contains('Reto Haldner'),
          ),
          DepotAccountData(
            depotName: '1507 CHF',
            accountNumber: 'CH13 0076 1001 5345 9150 7',
            balance: 'CHF 23\'495.94',
            fullValue:
                'Reto Haldner\n1507 CHF\nCH13 0076 1001 5345 9150 7\nCHF 23\'495.94',
            isSelected: selectedAccount.contains('1507 CHF') &&
                selectedAccount.contains('Reto Haldner'),
          ),
        ],
      ),
      AccountHolderData(
        name: 'Mareike Haldner',
        accounts: [
          DepotAccountData(
            depotName: '0934 EUR',
            accountNumber: 'CH61 0076 1001 5345 9093 4',
            balance: 'EUR 44\'388.13',
            fullValue:
                'Mareike Haldner\n0934 EUR\nCH61 0076 1001 5345 9093 4\nEUR 44\'388.13',
            isSelected: selectedAccount.contains('0934 EUR') &&
                selectedAccount.contains('Mareike Haldner'),
          ),
          DepotAccountData(
            depotName: '0903 CHF',
            accountNumber: 'CH25 0076 1001 5345 9093 3',
            balance: 'CHF 36\'546.06',
            fullValue:
                'Mareike Haldner\n0903 CHF\nCH25 0076 1001 5345 9093 3\nCHF 36\'546.06',
            isSelected: selectedAccount.contains('0903 CHF') &&
                selectedAccount.contains('Mareike Haldner'),
          ),
        ],
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: 56,
      ),
      itemCount: accountHolders.length,
      itemBuilder: (context, index) {
        final holder = accountHolders[index];
        return _buildAccountHolderSection(holder, isDark, index > 0);
      },
    );
  }

  Widget _buildAccountHolderSection(
      AccountHolderData holder, bool isDark, bool showTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Holder Name (only for second holder and onwards)
        if (showTitle) ...[
          const SizedBox(height: 32),
          Text(
            holder.name,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        // Account Cards
        ...holder.accounts.map((account) => _buildAccountCard(account, isDark)),
      ],
    );
  }

  Widget _buildAccountCard(DepotAccountData account, bool isDark) {
    final cardColor = account.isSelected
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
        onTap: () => onAccountSelected(account.fullValue),
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
                      account.depotName,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (account.isSelected)
                    Icon(
                      M3Icons.check,
                      size: 24,
                      color: checkColor,
                    ),
                ],
              ),
              // IBAN (closer to title to prevent overflow)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  account.accountNumber,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColorSchemes.greysMidGrey,
                  ),
                ),
              ),
              // 2px spacing between IBAN and Amount
              const SizedBox(height: 2),
              // Spacer to push Amount to bottom
              const Spacer(),
              // Amount row (right-aligned, 12px from bottom)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  account.balance,
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

class AccountHolderData {
  final String name;
  final List<DepotAccountData> accounts;

  AccountHolderData({
    required this.name,
    required this.accounts,
  });
}

class DepotAccountData {
  final String depotName;
  final String accountNumber;
  final String balance;
  final String fullValue;
  final bool isSelected;

  DepotAccountData({
    required this.depotName,
    required this.accountNumber,
    required this.balance,
    required this.fullValue,
    required this.isSelected,
  });
}
