import 'package:flutter/material.dart';
import '../../../core/currency/currency_scope.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart';

class StandingOrderDetailScreen extends StatelessWidget {
  final String recipient;
  final String amount;
  final String subtitle; // e.g., date | Standing Order
  final String? returnRoute;
  final Map<String, dynamic>? returnRouteExtra;

  const StandingOrderDetailScreen({
    super.key,
    required this.recipient,
    required this.amount,
    required this.subtitle,
    this.returnRoute,
    this.returnRouteExtra,
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
            // Header with only back button, routes back to previous page
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
                      onTap: () {
                        if (returnRoute != null) {
                          context.go(returnRoute!, extra: returnRouteExtra);
                        } else {
                          context.pop();
                        }
                      },
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

            // Header content
            TransactionHeader(
              title: recipient,
              subtitle: subtitle,
              amount: amount,
              originalAmount: null,
              isDark: isDark,
            ),

            // Divider below header
            Divider(
              color: isDark
                  ? AppColorSchemes.darkCardBackground
                  : const Color(0xFFDADADA),
              height: 1,
              thickness: 1,
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  const SizedBox(height: 16),

                  // Recipient with edit
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Recipient',
                      value: _buildRecipientBlock(recipient),
                      trailingAction: _actionIconButton(isDark),
                    ),
                    isDark: isDark,
                  ),

                  // Transfer Type
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Transfer Type',
                      value:
                          'Account Transfer\nMonthly execution on the 1st of the month,\nvalid until revoked.',
                    ),
                    isDark: isDark,
                  ),

                  // Reference
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Reference',
                      value: 'Monthly Savings',
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

                  // Amount with edit
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Amount',
                      value: context.withAppCurrency(amount),
                      trailingAction: _actionIconButton(isDark),
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

                  // Debit Account with edit
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Debit Account',
                      value: context.withAppCurrency(
                          "Peter Haldner\nPrivate Account\nCH85 9558 4848 4932 3332 2\nCHF 32'918.30"),
                      trailingAction: _actionIconButton(isDark),
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

                  const SizedBox(height: 24),
                  // Secondary actions
                  Row(
                    children: [
                      Expanded(
                        child: _secondaryActionButton(
                          isDark: isDark,
                          icon: Icons.delete,
                          label: 'Delete',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _secondaryActionButton(
                          isDark: isDark,
                          icon: Icons.edit,
                          label: 'Edit',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 56),
                ],
              ),
            ),

            AppBottomNavigation(
              activeRoute: returnRoute == '/account-preview' ? '/assets' : '/payments',
            ),
          ],
        ),
      ),
    );
  }

  String _buildRecipientBlock(String name) {
    return [
      'Savings Account',
      name,
      'CH65 8437 7219 8273 2',
      'CHF 2’918.00',
    ].join('\n');
  }

  Widget _actionIconButton(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF333333) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.edit,
        size: 24,
        color: isDark ? Colors.white : const Color(0xFF333333),
      ),
    );
  }

  Widget _secondaryActionButton({
    required bool isDark,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    const bg = Colors.white;
    const fg = Color(0xFF333333);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? bg.withValues(alpha: 0.12) : bg,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isDark ? Colors.white : fg),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
