import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// Transaction Detail Screen
/// Route expects: title, subtitle, amount, originalAmount (all String)
/// import 'package:go_router/go_router.dart';
/// import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
// Header-lv.2 (nur Back Button zur Account Transactions Seite)
class HeaderLv2 extends StatelessWidget {
  final bool isDark;
  const HeaderLv2({super.key, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Material(
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
              onTap: () => context.go('/account-transactions'),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : const Color(0xFF333333),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String? originalAmount;

  const TransactionDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.originalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<ValueListEntry> details = [
      ValueListEntry(
        label: 'Debit Account',
        value: 'Private Account',
      ),
      ValueListEntry(
        label: 'Booking Type',
        value: 'Twint Payment',
      ),
      ValueListEntry(
        label: 'Booking Text',
        value: 'My Amazon order from Germany',
      ),
      ValueListEntry(
        label: 'Valuta Date',
        value: '16. April 2025',
      ),
      ValueListEntry(
        label: 'Ref no.',
        value: '2506617816',
      ),
      ValueListEntry(
        label: 'Payment history (SWIFT GPI)\n\nDate',
        value: '18. April 2025 - 08:12 pm',
        subvalue: '',
      ),
    ];

    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderLv2(isDark: isDark),
            TransactionHeader(
              title: title,
              subtitle: subtitle,
              amount: amount,
              originalAmount: originalAmount,
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: details.length +
                    2, // zusätzliche Divider und Abstand unten für Button
                itemBuilder: (context, index) {
                  if (index < details.length) {
                    Widget child =
                        ValueListElement(entry: details[index], isDark: isDark);
                    if (index == 4 || index == 5) {
                      return Column(
                        children: [
                          child,
                          Divider(
                            color: isDark
                                ? AppColorSchemes.darkCardBackground
                                : const Color(0xFFDADADA),
                            height: 1,
                            thickness: 1,
                          ),
                        ],
                      );
                    }
                    return child;
                  } else if (index == details.length + 1 - 1) {
                    return const SizedBox(height: 56);
                  } else {
                    // BUTTON
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 56.0),
                      child: AppFilledButton(
                        text: 'Start Request',
                        icon: Icons.question_answer,
                        onPressed: () {
                          // Handle start request
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            const AppBottomNavigation(activeRoute: '/assets'),
          ],
        ),
      ),
    );
  }
}

// Der neue TransactionHeader mit gewünschtem CHF-Color-Split und Semibold Amount
class TransactionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String? originalAmount;
  final bool isDark;

  const TransactionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.originalAmount,
    required this.isDark,
  });

  InlineSpan _buildChfAmountSpan(BuildContext context, String amount, bool isDark) {
    final activeColor = AppColorSchemes.primaryDarkYellow;
    final displayAmount = context.withAppCurrency(amount);
    final currency = context.appCurrency;
    if (!displayAmount.startsWith(currency)) {
      return TextSpan(
        text: displayAmount,
        style: GoogleFonts.openSans(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF333333),
        ),
      );
    }
    final amountNum = displayAmount.replaceFirst(currency, '').trim();
    return TextSpan(
      children: [
        TextSpan(
          text: '$currency ',
          style: GoogleFonts.openSans(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: activeColor,
          ),
        ),
        TextSpan(
          text: amountNum,
          style: GoogleFonts.openSans(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 12, AppSpacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF333333),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: _buildChfAmountSpan(context, amount, isDark),
            ),
          ),
          if (originalAmount != null && originalAmount!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                context.withAppCurrency(originalAmount!),
                textAlign: TextAlign.right,
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: isDark ? Colors.white : const Color(0xFF333333),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class ValueListEntry {
  final String label;
  final String value;
  final String? subvalue;
  final Widget? trailingAction;

  ValueListEntry({
    required this.label,
    required this.value,
    this.subvalue,
    this.trailingAction,
  });
}

class ValueListElement extends StatelessWidget {
  final ValueListEntry entry;
  final bool isDark;
  const ValueListElement(
      {super.key, required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Labels & Values
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: isDark ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                if (entry.subvalue != null && entry.subvalue!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.subvalue!,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF888888),
                    ),
                  )
                ]
              ],
            ),
          ),
          if (entry.trailingAction != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: entry.trailingAction,
            )
        ],
      ),
    );
  }
}
