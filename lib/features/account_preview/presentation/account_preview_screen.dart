import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Account Preview Screen
///
/// Figma frame: Account - Preview (66:4629)
/// Shows account preview with graph and monthly standing orders
class AccountPreviewScreen extends StatefulWidget {
  final String accountName;
  final String accountBalance;
  final String accountType;

  const AccountPreviewScreen({
    super.key,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
  });

  @override
  State<AccountPreviewScreen> createState() => _AccountPreviewScreenState();
}

class _AccountPreviewScreenState extends State<AccountPreviewScreen> {
  final bool _isNumbersVisible = true;
  String _selectedPeriod = '2 Months'; // '2 Months' or '12 Months'
  int _selectedBarIndex = 1; // Start with bar 2 (index 1) as active

  // Amount values for each bar
  final List<String> _barAmounts = [
    "CHF 3'030.28", // Bar 1
    "CHF 4'000.00", // Bar 2 (default active)
    "CHF 3'538.34", // Bar 3
    "CHF 3'894.23", // Bar 4
    "CHF 2'460.34", // Bar 5
  ];

  // Date values for each bar
  final List<String> _barDates = [
    '1. April 2025', // Bar 1
    '15. April 2025', // Bar 2
    '1. June 2025', // Bar 3
    '15. June 2025', // Bar 4
    '1. July 2025', // Bar 5
  ];

  void _selectBar(int index) {
    setState(() {
      _selectedBarIndex = index;
    });
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
              _buildAccountHeader(isDark),
              _buildTabs(isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      _buildAccountPreviewGraph(isDark),
                      const SizedBox(height: AppSpacing.lg),
                      _buildTransactionList(isDark),
                    ],
                  ),
                ),
              ),
              const AppBottomNavigation(activeRoute: '/account-preview'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final iconColor = AppColorSchemes.getTextColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => context.go('/assets'),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                M3Icons.arrowBack,
                color: iconColor,
                size: 24,
              ),
            ),
          ),

          const Spacer(),

          // Details Button
          Text(
            'Details',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              widget.accountName,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.normal,
                color: AppColorSchemes.getTextColor(isDark),
              ),
            ),
          ),

          // Amount Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              children: [
                // Main Balance - rechtsbündig mit 16px Abstand
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      right: AppSpacing.md), // 16px Abstand rechts
                  child: _isNumbersVisible
                      ? RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'CHF ',
                                style: GoogleFonts.openSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600, // Semibold
                                  color: AppColorSchemes.amountAccentColor,
                                ),
                              ),
                              TextSpan(
                                text: widget.accountBalance
                                    .replaceFirst('CHF ', ''),
                                style: GoogleFonts.openSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600, // Semibold
                                  color: AppColorSchemes.getTextColor(isDark),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          '••••••••',
                          style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w600, // Semibold
                            color: AppColorSchemes.greysMidGrey,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.right,
                        ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Available Balance - rechtsbündig mit 16px Abstand
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      right: AppSpacing.md), // 16px Abstand rechts
                  child: _isNumbersVisible
                      ? RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Available ',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColorSchemes.getTextColor(isDark),
                                ),
                              ),
                              TextSpan(
                                text: 'CHF ',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColorSchemes.amountAccentColor,
                                ),
                              ),
                              TextSpan(
                                text: widget.accountBalance
                                    .replaceFirst('CHF ', ''),
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColorSchemes.getTextColor(isDark),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          'Available ••••••••',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColorSchemes.greysMidGrey,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Pay Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: AppColorSchemes.lightButtonBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                // Handle pay action
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    M3Icons.qrCodeScanner,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Pay',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
              height: 40), // 40px Abstand zwischen Pay Button und Tabbar
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transactions Tab (Inactive)
              InkWell(
                onTap: () {
                  context.go('/account-transactions', extra: {
                    'accountName': widget.accountName,
                    'accountBalance': widget.accountBalance,
                    'accountType': widget.accountType,
                  });
                },
                child: Text(
                  'Transactions',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColorSchemes.getTextColor(isDark),
                  ),
                ),
              ),

              const SizedBox(width: 32),

              // Preview Tab (Active)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Preview',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColorSchemes.primaryDarkYellow,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 2,
                    width: 64,
                    color: AppColorSchemes.primaryDarkYellow,
                  ),
                ],
              ),

              const Spacer(),

              // Search Icon Button - 8px nach oben positioniert
              Transform.translate(
                offset: const Offset(0, -8),
                child: InkWell(
                  onTap: () {
                    // Handle search action
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
        // Divider direkt unterhalb der Tabs ohne Abstand
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

  Widget _buildAccountPreviewGraph(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Header - rechtsbündig
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _isNumbersVisible
                    ? Text(
                        _barAmounts[_selectedBarIndex],
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColorSchemes.getTextColor(isDark),
                        ),
                      )
                    : Text(
                        '••••••',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColorSchemes.greysMidGrey,
                        ),
                      ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _barDates[_selectedBarIndex],
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColorSchemes.greysMidGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Graph with Y-axis labels and bars
          _buildGraph(isDark),
          const SizedBox(height: AppSpacing.md),
          // Month labels (X-axis)
          _buildMonthLabels(),
          const SizedBox(height: AppSpacing.md),
          // Segmented Control
          _buildSegmentedControl(isDark),
        ],
      ),
    );
  }

  Widget _buildGraph(bool isDark) {
    const double maxHeight = 172;
    return SizedBox(
      height: maxHeight,
      width: 360, // Fixed width for Y-axis container
      child: Stack(
        children: [
          // Y-axis with labels filling the container
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top label (CHF 4'000) above divider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHF 4\'000',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Container(
                        height: 1,
                        color: isDark
                            ? AppColorSchemes.darkCardBackground
                            : AppColorSchemes.greysLightGrey),
                  ],
                ),
                // Middle label (CHF 3'000) above divider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHF 3\'000',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Container(
                        height: 1,
                        color: isDark
                            ? AppColorSchemes.darkCardBackground
                            : AppColorSchemes.greysLightGrey),
                  ],
                ),
                // Bottom label (CHF 2'000) above divider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHF 2\'000',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Container(
                        height: 1,
                        color: isDark
                            ? AppColorSchemes.darkCardBackground
                            : AppColorSchemes.greysLightGrey),
                  ],
                ),
              ],
            ),
          ),
          // Bars positioned from bottom over Y-axis with 100px spacing
          Positioned(
            bottom: 0,
            left: 100, // 100px Abstand zur Y-Achse
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Bar 1 - 80px height
                _buildBar(0, 80),
                // Bar 2 - 148px height (default active)
                _buildBar(1, 148),
                // Bar 3 - 95px height
                _buildBar(2, 95),
                // Bar 4 - 110px height
                _buildBar(3, 110),
                // Bar 5 - 44px height
                _buildBar(4, 44),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index, double height) {
    final bool isActive = _selectedBarIndex == index;
    return InkWell(
      onTap: () => _selectBar(index),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: height,
        decoration: BoxDecoration(
          color: isActive
              ? AppColorSchemes.primaryDarkYellow
              : AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildMonthLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Spacer for Y-axis labels
        const SizedBox(width: 80),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Apr',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
              Text(
                'Jun',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
              Text(
                'Jul',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(bool isDark) {
    final containerColor =
        isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final selectedBgColor = AppColorSchemes.primaryDarkYellow;
    final unselectedTextColor =
        isDark ? Colors.white : AppColorSchemes.greysDarkGrey;
    final selectedTextColor = AppColorSchemes.greysDarkGrey;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPeriod = '2 Months';
                });
              },
              child: Container(
                height: 37,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _selectedPeriod == '2 Months'
                      ? selectedBgColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '2 Months',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedPeriod == '2 Months'
                          ? selectedTextColor
                          : unselectedTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPeriod = '12 Months';
                });
              },
              child: Container(
                height: 37,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _selectedPeriod == '12 Months'
                      ? selectedBgColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '12 Months',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedPeriod == '12 Months'
                          ? selectedTextColor
                          : unselectedTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 24), // Spacing between Tabbar and May 2025
        // May 2025 Section
        _buildTransactionSection(
          title: 'May 2025',
          transactions: _getMayTransactions(),
          isDark: isDark,
        ),
        const SizedBox(height: 24), // Spacing between Car Finance and June 2025
        // June 2025 Section
        _buildTransactionSection(
          title: 'June 2025',
          transactions: _getJuneTransactions(),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildTransactionSection({
    required String title,
    required List<TransactionData> transactions,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColorSchemes.greysMidGrey,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...transactions
            .map((transaction) => _buildTransactionItem(transaction, isDark)),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionData transaction, bool isDark) {
    final isStandingOrder = transaction.date.contains('Standing Order');
    
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
                      transaction.merchant,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.getTextColor(isDark),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      transaction.date,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _isNumbersVisible
                      ? Text(
                          transaction.amount,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColorSchemes.getTextColor(isDark),
                          ),
                        )
                      : Text(
                          '••••',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColorSchemes.greysMidGrey,
                            letterSpacing: 1,
                          ),
                        ),
                  if (transaction.originalAmount.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    _isNumbersVisible
                        ? Text(
                            transaction.originalAmount,
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColorSchemes.greysMidGrey,
                            ),
                          )
                        : Text(
                            '••••',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColorSchemes.greysMidGrey,
                              letterSpacing: 1,
                            ),
                          ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(
            color: isDark
                ? AppColorSchemes.darkCardBackground
                : AppColorSchemes.greysLightGrey,
            height: 1,
          ),
        ],
      ),
    );

    if (isStandingOrder) {
      return InkWell(
        onTap: () {
          context.push('/standing-order-detail', extra: {
            'recipient': transaction.merchant,
            'amount': transaction.amount,
            'subtitle': transaction.date,
            'returnRoute': '/account-preview',
            'returnRouteExtra': {
              'accountName': widget.accountName,
              'accountBalance': widget.accountBalance,
              'accountType': widget.accountType,
            },
          });
        },
        child: content,
      );
    }

    return content;
  }

  // Transaction data methods
  List<TransactionData> _getMayTransactions() {
    return [
      TransactionData(
        merchant: 'Savings Account',
        date: '29. May | Standing Order',
        amount: 'CHF –1\'200.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Reto Haldner',
        date: '25. May | Standing Order',
        amount: 'CHF –200.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Credit24.ch',
        date: '25. May | Standing Order',
        amount: 'CHF –500.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Rent Appartment',
        date: '01. May | Standing Order',
        amount: 'CHF –2\'800.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Car Finance',
        date: '01. May | Standing Order',
        amount: 'CHF –300.00',
        originalAmount: '',
      ),
    ];
  }

  List<TransactionData> _getJuneTransactions() {
    return [
      TransactionData(
        merchant: 'Savings Account',
        date: '29. June | Standing Order',
        amount: 'CHF –1\'200.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Reto Haldner',
        date: '25. June | Standing Order',
        amount: 'CHF –200.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Credit24.ch',
        date: '25. June | Standing Order',
        amount: 'CHF –500.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Rent Appartment',
        date: '01. June | Standing Order',
        amount: 'CHF –2\'800.00',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Car Finance',
        date: '01. June | Standing Order',
        amount: 'CHF –300.00',
        originalAmount: '',
      ),
    ];
  }
}

// Transaction data class
class TransactionData {
  final String merchant;
  final String date;
  final String amount;
  final String originalAmount;

  TransactionData({
    required this.merchant,
    required this.date,
    required this.amount,
    this.originalAmount = '',
  });
}
