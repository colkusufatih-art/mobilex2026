import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart';

class OpenPaymentDetailScreen extends StatelessWidget {
  final String recipient;
  final String amount;
  final String subtitle; // e.g., date/status text from list

  const OpenPaymentDetailScreen({
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
            // Header with only back button, routes back to payments
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

            // Header content (title, subtitle, amount) matches TransactionHeader pattern
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

            // Content list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  const SizedBox(height: 16),
                  // Recipient (multi-line address) with trailing edit
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Recipient',
                      value: _buildRecipientBlock(recipient),
                      trailingAction: _actionIconButton(isDark),
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

                  // Amount with trailing edit
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

                  // Debit Account with trailing edit
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

                  // Confidential
                  ValueListElement(
                    entry: ValueListEntry(
                      label: 'Confidental',
                      value: 'No',
                    ),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),

                  // Secondary row of actions: Delete, Edit
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

                  const SizedBox(height: AppSpacing.sm),

                  // Approve Button
                  _approveButton(isDark),

                  const SizedBox(height: 56),
                ],
              ),
            ),

            // Bottom navigation with Payments active
            const AppBottomNavigation(activeRoute: '/payments'),
          ],
        ),
      ),
    );
  }

  // Helper: compose multi-line recipient block
  String _buildRecipientBlock(String name) {
    // Fallback multi-line demo content mirroring Figma until wired to data source
    return [
      name,
      'CH65 8437 7219 8273 2',
      'Brunaustrasse 75',
      '8008 Zürich',
      'Schweiz',
    ].join('\n');
  }

  // Helper: small square edit action per dark/light
  // WCAG 2.2: Semantics und Tooltip hinzugefügt
  Widget _actionIconButton(bool isDark) {
    return Semantics(
      button: true,
      label: 'Bearbeiten',
      child: Tooltip(
        message: 'Bearbeiten',
        child: Container(
          width: 48, // WCAG 2.5: Minimum Touch Target
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF333333) : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.edit,
              size: 24,
              color: isDark ? Colors.white : const Color(0xFF333333),
              semanticLabel: 'Bearbeiten',
            ),
          ),
        ),
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
    // WCAG 2.2: Semantics für Action Button
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
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
              Icon(icon, size: 20, color: isDark ? Colors.white : fg, semanticLabel: label),
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
      ),
    );
  }

  Widget _approveButton(bool isDark) {
    const bgColor = Color(0xFF333333); // Dark grey background
    const fgColor = Colors.white;
    
    return InkWell(
      onTap: () {
        // Approve functionality will be implemented
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? bgColor.withValues(alpha: 0.8) : bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              M3Icons.check,
              size: 20,
              color: fgColor,
            ),
            const SizedBox(width: 12),
            Text(
              'Approve',
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
