import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobilex2025/core/currency/currency_scope.dart';
import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/core/theme/radius.dart';
import 'package:mobilex2025/core/icons/m3_icons.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';

import '../domain/payment_draft.dart';
import '../domain/account_transfer_draft.dart';

/// Payments Screen
/// Duplicate of Account Transactions with a Payments header and ExternalCardLink
class PaymentsScreen extends StatefulWidget {
  final PaymentDraft? newPayment;
  final AccountTransferDraft? newAccountTransfer;
  final int? selectedTab;
  const PaymentsScreen({
    super.key,
    this.newPayment,
    this.newAccountTransfer,
    this.selectedTab,
  });

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late int _selectedTab;
  late List<_PaymentItem> _openPayments;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.selectedTab ?? 0;
    _openPayments = _getOpenPayments();
    _maybeInsertNewPayment(widget.newPayment);
    _maybeInsertNewAccountTransfer(widget.newAccountTransfer);
  }

  @override
  void didUpdateWidget(covariant PaymentsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.newPayment != oldWidget.newPayment) {
      _openPayments = _getOpenPayments();
      _maybeInsertNewPayment(widget.newPayment);
    }
    if (widget.newAccountTransfer != oldWidget.newAccountTransfer) {
      _openPayments = _getOpenPayments();
      _maybeInsertNewAccountTransfer(widget.newAccountTransfer);
    }
    if (widget.selectedTab != oldWidget.selectedTab &&
        widget.selectedTab != null) {
      setState(() {
        _selectedTab = widget.selectedTab!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(isDark),
              PaymentsHeader(
                isDark: isDark,
                onPayTap: () =>
                    GoRouter.of(context).push('/payments/new-payment'),
              ),
              ExternalLinkCard(
                isDark: isDark,
                onTap: () async {
                  final uri = Uri.parse('https://ebill.ch/ebill-portal/ui/payments/by-due-date');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(height: 32),
              _buildTabs(isDark),
              const SizedBox(height: 32),
              Expanded(
                child: _buildPaymentsContent(isDark),
              ),
              const AppBottomNavigation(activeRoute: '/payments'),
            ],
          ),
        ),
      ),
    );
  }

  // Header row with right-aligned "Settings"
  Widget _buildHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Settings',
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    // Replicate Account Transactions tabbar pattern: 3 tabs + search icon + divider
    TextStyle activeStyle = GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColorSchemes.primaryDarkYellow,
    );
    TextStyle inactiveStyle = GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColorSchemes.getTextColor(isDark),
    );

    Widget buildTab(String label, int index) {
      final active = _selectedTab == index;
      return GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: active ? activeStyle : inactiveStyle),
              const SizedBox(height: AppSpacing.xs),
              if (active)
                Container(
                  height: 2,
                  width: double.infinity,
                  color: AppColorSchemes.primaryDarkYellow,
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // horizontally scrollable tabs
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildTab('Payments', 0),
                      const SizedBox(width: 32),
                      buildTab('Standing Orders', 1),
                      const SizedBox(width: 32),
                      buildTab('Archived Payments', 2),
                    ],
                  ),
                ),
              ),
              // Search icon pinned right
              Transform.translate(
                offset: const Offset(0, -8),
                child: InkWell(
                  onTap: () {
                    context.push('/payments/search');
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColorSchemes.greysDarkGrey : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      M3Icons.search,
                      color:
                          isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: isDark
              ? AppColorSchemes.darkCardBackground
              : AppColorSchemes.greysLightGrey,
        ),
      ],
    );
  }

  Widget _buildPaymentsContent(bool isDark) {
    if (_selectedTab == 0) {
      // Payments tab content
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            _buildPaymentSection(
              title: 'Open Payments',
              transactions: _openPayments,
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(
                color: isDark
                    ? AppColorSchemes.darkCardBackground
                    : AppColorSchemes.greysLightGrey,
                height: 1),
            const SizedBox(height: AppSpacing.md),
            _buildPaymentSection(
              title: 'Past Payments',
              transactions: _getPastPaymentsFigma(),
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(
                color: isDark
                    ? AppColorSchemes.darkCardBackground
                    : AppColorSchemes.greysLightGrey,
                height: 1),
            const SizedBox(height: AppSpacing.md),
            _buildPaymentSection(
              title: 'April 2025',
              transactions: _getAprilPayments(),
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      );
    } else if (_selectedTab == 1) {
      // Standing Orders content (Figma data)
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            _buildPaymentSection(
              title: 'June 2025',
              transactions: _getStandingOrdersJune(),
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(
                color: isDark
                    ? AppColorSchemes.darkCardBackground
                    : AppColorSchemes.greysLightGrey,
                height: 1),
            const SizedBox(height: AppSpacing.md),
            _buildPaymentSection(
              title: 'May 2025',
              transactions: _getStandingOrdersMay(),
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      );
    } else if (_selectedTab == 2) {
      // Archived Payments (Figma content)
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            _buildPaymentSection(
              title: 'Past Transactions',
              transactions: _getArchivedPastTransactions(),
              isDark: isDark,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _maybeInsertNewPayment(PaymentDraft? draft) {
    if (draft == null) {
      return;
    }
    final name = draft.recipientName.isNotEmpty
        ? draft.recipientName
        : _firstLine(draft.recipientSummary);
    final displayName = name.isNotEmpty ? name : 'Recipient';
    final amount = draft.formattedAmount;
    final date = '${draft.formatDate(draft.executionDate)} | Pending';

    _openPayments.insert(
      0,
      _PaymentItem(
        merchant: displayName,
        amount: amount,
        date: date,
      ),
    );
  }

  void _maybeInsertNewAccountTransfer(AccountTransferDraft? draft) {
    if (draft == null) {
      return;
    }
    // Extract name from toAccount (first line)
    final name = _firstLine(draft.toAccount);
    final displayName = name.isNotEmpty ? name : 'Account Transfer';
    final amount = draft.formattedAmount;
    final date = '${draft.formatDate(draft.executionDate)} | Account Transfer';

    _openPayments.insert(
      0,
      _PaymentItem(
        merchant: displayName,
        amount: amount,
        date: date,
      ),
    );
  }

  String _firstLine(String value) {
    if (value.isEmpty) {
      return '';
    }
    final parts = value.split('\n');
    return parts.isNotEmpty ? parts.first : value;
  }

  Widget _buildPaymentSection({
    required String title,
    required List<_PaymentItem> transactions,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColorSchemes.greysMidGrey,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(transactions.length, (index) {
          final item = transactions[index];
          final isLast = index == transactions.length - 1;
          // Only Open Payments should navigate to detail
          final bool isOpenPayments = title == 'Open Payments';
          final bool isStandingOrders =
              title.contains('June 2025') || title.contains('May 2025');
          final bool isArchived = title == 'Past Transactions';
          final bool hideDivider =
              (title == 'Open Payments' && item.merchant == 'Clara Lehmann') ||
                  (title == 'June 2025' && item.merchant == 'Car Finance');
          return _buildPaymentItem(
            context,
            item,
            isDark,
            showDivider: !isLast && !hideDivider,
            onTap: isOpenPayments
                ? () {
                    context.go('/open-payment-detail', extra: {
                      'recipient': item.merchant,
                      'amount': item.amount,
                      'subtitle': item.date,
                    });
                  }
                : isStandingOrders
                    ? () {
                        context.push('/standing-order-detail', extra: {
                          'recipient': item.merchant,
                          'amount': item.amount,
                          'subtitle': item.date,
                          'returnRoute': '/payments',
                          'returnRouteExtra': {
                            'selectedTab': 1, // Standing Orders tab
                          },
                        });
                      }
                    : isArchived
                        ? () {
                            context.go('/archived-payment-detail', extra: {
                              'recipient': item.merchant,
                              'amount': item.amount,
                              'subtitle': item.date,
                            });
                          }
                        : null,
          );
        }),
      ],
    );
  }

  Widget _buildPaymentItem(
      BuildContext context, _PaymentItem p, bool isDark,
      {bool showDivider = true, VoidCallback? onTap}) {
    final content = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.merchant,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.getTextColor(isDark),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      p.date,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.withAppCurrency(p.amount),
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColorSchemes.getTextColor(isDark),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: AppSpacing.sm),
            Divider(
                color: isDark
                    ? AppColorSchemes.darkCardBackground
                    : AppColorSchemes.greysLightGrey,
                height: 1),
          ],
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  // Rename/adjust datasets to match Figma content
  List<_PaymentItem> _getOpenPayments() {
    return [
      _PaymentItem(
          merchant: 'Martin Wenger',
          amount: 'CHF 50.00',
          date: '21. May 2025 | Pending'),
      _PaymentItem(
          merchant: 'Migros Stadelhofen',
          amount: 'CHF 400.00',
          date: '30. May 2025 | Pending'),
      _PaymentItem(
          merchant: 'Peter Baumgartner',
          amount: 'CHF 400.00',
          date: '30. May 2025 | Partially signed'),
      _PaymentItem(
          merchant: 'Clara Lehmann',
          amount: 'CHF 240.00',
          date: '10. January 2025 | Pending'),
    ];
  }

  List<_PaymentItem> _getPastPaymentsFigma() {
    return [
      _PaymentItem(
          merchant: 'Martin Wenger', amount: 'CHF 50.00', date: '21. May'),
      _PaymentItem(
          merchant: 'Sanitas\nKrankenversicherung',
          amount: 'CHF 400.00',
          date: '30. May'),
      _PaymentItem(
          merchant: 'Peter Baumgartner', amount: 'CHF 60.00', date: '16. May'),
    ];
  }

  List<_PaymentItem> _getAprilPayments() {
    return [
      _PaymentItem(
          merchant: 'Martin Wenger', amount: 'CHF 50.00', date: '21. April'),
      _PaymentItem(
          merchant: 'Sanitas\nKrankenversicherung',
          amount: 'CHF 400.00',
          date: '30. April'),
      _PaymentItem(
          merchant: 'Peter Baumgartner',
          amount: 'CHF 60.00',
          date: '16. April'),
      _PaymentItem(
          merchant: 'Clara Lehmann', amount: 'CHF 240.00', date: '12. April'),
    ];
  }

  List<_PaymentItem> _getStandingOrdersJune() {
    return [
      _PaymentItem(
          merchant: 'Savings Account',
          amount: 'CHF –1’200.00',
          date: '29. June | Standing Order'),
      _PaymentItem(
          merchant: 'Reto Haldner',
          amount: 'CHF –200.00',
          date: '25. June | Standing Order'),
      _PaymentItem(
          merchant: 'Credit24.ch',
          amount: 'CHF –500.00',
          date: '25. June | Standing Order'),
      _PaymentItem(
          merchant: 'Rent Appartment',
          amount: 'CHF –2’800.00',
          date: '01. June | Standing Order'),
      _PaymentItem(
          merchant: 'Car Finance',
          amount: 'CHF –300.00',
          date: '01. June | Standing Order'),
    ];
  }

  List<_PaymentItem> _getStandingOrdersMay() {
    return [
      _PaymentItem(
          merchant: 'Savings Account',
          amount: 'CHF –1’200.00',
          date: '29. May | Standing Order'),
      _PaymentItem(
          merchant: 'Reto Haldner',
          amount: 'CHF –200.00',
          date: '25. May | Standing Order'),
      _PaymentItem(
          merchant: 'Credit24.ch',
          amount: 'CHF –500.00',
          date: '25. May | Standing Order'),
      _PaymentItem(
          merchant: 'Rent Appartment',
          amount: 'CHF –2’800.00',
          date: '01. May | Standing Order'),
      _PaymentItem(
          merchant: 'Car Finance',
          amount: 'CHF –300.00',
          date: '01. May | Standing Order'),
    ];
  }

  List<_PaymentItem> _getArchivedPastTransactions() {
    return [
      _PaymentItem(
          merchant: 'Migros Limmatplatz, Zurich Retro LTD',
          amount: 'CHF –53.30',
          date: '25. April | 8:12 pm'),
      _PaymentItem(
          merchant: 'SBB Easyride',
          amount: 'CHF –123.30',
          date: '25. April | 8:12 pm'),
      _PaymentItem(
          merchant: 'Twint Martin Wenger',
          amount: 'CHF –23.30',
          date: '15. April | 8:12 pm'),
      _PaymentItem(
          merchant: 'Amazon Germany',
          amount: 'CHF –123.30',
          date: '14. April | 8:12 pm'),
      _PaymentItem(
          merchant: 'IKEA Schweiz',
          amount: 'CHF –2’323.30',
          date: '13. April | 8:12 pm'),
      _PaymentItem(
          merchant: 'IKEA Schweiz',
          amount: 'CHF –1’323.30',
          date: '11. April | 8:12 pm'),
    ];
  }
}

// Simple payments header component directly below the header
class PaymentsHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPayTap;
  const PaymentsHeader(
      {super.key, required this.isDark, required this.onPayTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          Text(
            'Payments',
            style: GoogleFonts.openSans(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColorSchemes.getTextColor(isDark),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 32),
          _PaymentsQuickActions(isDark: isDark, onPayTap: onPayTap),
          const SizedBox(height: 32), // **Neuer Abstand zu External Link Card**
        ],
      ),
    );
  }
}

class _PaymentsQuickActions extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPayTap;
  const _PaymentsQuickActions({required this.isDark, required this.onPayTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSquaredButton(
            icon: M3Icons.qrCodeScanner,
            text: 'Scan',
            isDark: isDark,
            onTap: () => GoRouter.of(context).push('/payments/qr-scan'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildSquaredButton(
            icon: Icons.add, // plus
            text: 'Pay',
            isDark: isDark,
            onTap: onPayTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildSquaredButton(
            icon: Icons.compare_arrows,
            text: 'Transfer',
            isDark: isDark,
            onTap: () =>
                GoRouter.of(context).push('/payments/account-transfer'),
          ),
        ),
      ],
    );
  }

  Widget _buildSquaredButton({
    required IconData icon,
    required String text,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    final borderRadius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: AppColorSchemes.getCardBackgroundColor(isDark),
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: AppColorSchemes.getTextColor(isDark)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                text,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExternalLinkCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String? subtitle;
  final bool showDot;
  final VoidCallback? onTap;

  const ExternalLinkCard({
    super.key,
    required this.isDark,
    this.title = 'eBill',
    this.subtitle,
    this.showDot = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF333333) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF333333);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.openSans(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          subtitle!,
                          style: GoogleFonts.openSans(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (showDot)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 6,
                            height: 6,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColorSchemes.primaryDarkYellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(M3Icons.arrowOutward, size: 24, color: textColor),
          ],
        ),
        ),
      ),
    );
  }
}

class _PaymentItem {
  final String merchant;
  final String amount;
  final String date;
  _PaymentItem(
      {required this.merchant, required this.amount, required this.date});
}
