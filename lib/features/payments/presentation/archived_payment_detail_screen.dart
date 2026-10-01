import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart';

class ArchivedPaymentDetailScreen extends StatelessWidget {
  final String recipient;
  final String amount;
  final String subtitle; // e.g., date/time

  const ArchivedPaymentDetailScreen({
    super.key,
    required this.recipient,
    required this.amount,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back to payments
            Material(
              color: isDark
                  ? AppColorSchemes.darkBackground
                  : AppColorSchemes.lightBackground,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => context.go('/payments'),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.arrow_back,
                          color:
                              isDark ? Colors.white : const Color(0xFF333333),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Header content using TransactionHeader for title/subtitle/amount
            TransactionHeader(
              title: recipient,
              subtitle: subtitle,
              amount: amount,
              originalAmount: null,
              isDark: isDark,
            ),

            Divider(
              color: isDark
                  ? AppColorSchemes.darkCardBackground
                  : const Color(0xFFDADADA),
              height: 1,
              thickness: 1,
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  const SizedBox(height: 16),

                  // Recipient (read-only here)
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Recipient',
                      value: _buildRecipientBlock(recipient),
                    ),
                    isDark: isDark,
                  ),

                  // Bank
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Bank',
                      value: 'Basler Kantonalbank\n770',
                    ),
                    isDark: isDark,
                  ),

                  // Reference
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Reference',
                      value: 'Payment Dinner',
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: isDark
                        ? AppColorSchemes.darkCardBackground
                        : const Color(0xFFDADADA),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 12),

                  // Amount (read-only)
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Amount',
                      value: context.withAppCurrency(amount),
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: isDark
                        ? AppColorSchemes.darkCardBackground
                        : const Color(0xFFDADADA),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 12),

                  // Debit Account (read-only)
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Debit Account',
                      value: context.withAppCurrency(
                          "Peter Haldner\nPrivate Account\nCH85 9558 4848 4932 3332 2\nCHF 32'918.30"),
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: isDark
                        ? AppColorSchemes.darkCardBackground
                        : const Color(0xFFDADADA),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 12),

                  // Execution date
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Execution date',
                      value: '12.04.2025',
                    ),
                    isDark: isDark,
                  ),

                  // Debit note
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Debit note',
                      value: 'Standard',
                    ),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 56),
                ],
              ),
            ),

            const AppBottomNavigation(activeRoute: '/payments'),
          ],
        ),
      ),
    );
  }

  String _buildRecipientBlock(String name) {
    return [
      name,
      'CH65 8437 7219 1654 1',
      'Limmatplatz 152',
      '8105 Zürich',
      'Schweiz',
    ].join('\n');
  }
}
