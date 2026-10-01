import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../core/account/account_notifier.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../app.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Account Transactions Screen
/// 
/// Figma frame: Account - Transactions (27:3658)
/// Shows transaction details for a specific account
class AccountTransactionsScreen extends StatefulWidget {
  final String accountName;
  final String accountBalance;
  final String accountType;

  const AccountTransactionsScreen({
    super.key,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
  });

  @override
  State<AccountTransactionsScreen> createState() =>
      _AccountTransactionsScreenState();
}

class _AccountTransactionsScreenState extends State<AccountTransactionsScreen> {
  final bool _isNumbersVisible = true;
  late AccountNotifier _accountNotifier;
  int _selectedTabIndex = 0; // 0 = Transactions, 1 = Preview
  String _selectedPeriod = '2 Months'; // For Preview tab
  int _selectedBarIndex = 1; // For Preview tab graph
  
  // Amount values for each bar in Preview
  final List<String> _barAmounts = [
    "CHF 3'030.28", // Bar 1
    "CHF 4'000.00", // Bar 2 (default active)
    "CHF 3'538.34", // Bar 3
    "CHF 3'894.23", // Bar 4
    "CHF 2'460.34", // Bar 5
  ];

  // Date values for each bar in Preview
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
  void initState() {
    super.initState();
    _accountNotifier = context.accountNotifier!;
    _accountNotifier.addListener(_onAliasChanged);
  }

  @override
  void dispose() {
    _accountNotifier.removeListener(_onAliasChanged);
    super.dispose();
  }

  void _onAliasChanged() {
    setState(() {
      // Rebuild when alias changes
    });
  }

  String get _displayAccountName {
    return _accountNotifier.getAlias(widget.accountName);
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
              const SizedBox(
                  height:
                      32), // 32px Abstand zwischen Tabbar und Content
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildTransactionList(isDark)
                    : _buildPreviewContent(isDark),
              ),
              const AppBottomNavigation(activeRoute: '/account-transactions'),
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
          
          // Details Button (ohne Scan Icon und weißen Hintergrund)
          InkWell(
            onTap: () => context.go(
              '/account-detail',
              extra: {'accountTitle': widget.accountName},
            ),
            child: Text(
              'Details',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
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
        children: [
          // Account Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              _displayAccountName,
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
                                text: '${context.appCurrency} ',
                                style: GoogleFonts.openSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600, // Semibold
                                  color: AppColorSchemes.amountAccentColor,
                                ),
                              ),
                              TextSpan(
                                text: context
                                    .withAppCurrency(widget.accountBalance)
                                    .replaceFirst('${context.appCurrency} ', ''),
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
                                text: '${context.appCurrency} ',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColorSchemes.amountAccentColor,
                                ),
                              ),
                              TextSpan(
                                text: context
                                    .withAppCurrency(widget.accountBalance)
                                    .replaceFirst('${context.appCurrency} ', ''),
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
          
          // Pay Button
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColorSchemes.lightButtonBackground,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: InkWell(
              onTap: () {
                _showPayBottomSheet(context);
              },
              borderRadius: BorderRadius.circular(AppRadius.sm),
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
          
          // 40px Abstand zwischen Pay Button und Tabbar
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    final activeColor = AppColorSchemes.primaryDarkYellow;
    final inactiveColor = AppColorSchemes.getTextColor(isDark);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transactions Tab - linksbündig
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Transactions',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedTabIndex == 0
                                ? activeColor
                                : inactiveColor,
                          ),
                        ),
                        if (_selectedTabIndex == 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: activeColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 32),
              
              // Preview Tab - linksbündig
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Preview',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedTabIndex == 1
                                ? activeColor
                                : inactiveColor,
                          ),
                        ),
                        if (_selectedTabIndex == 1) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: activeColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Search Icon Button - 8px nach oben positioniert
              Transform.translate(
                offset: const Offset(0, -8),
                child: InkWell(
                  onTap: () {
                    context.push('/account-transactions/search');
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

  Widget _buildTransactionList(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          // Open Transactions Section
          _buildTransactionSection(
            title: 'Open Transactions',
            transactions: _getOpenTransactions(),
            isDark: isDark,
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Past Transactions Section
          _buildTransactionSection(
            title: 'Past Transactions',
            transactions: _getPastTransactions(),
            isDark: isDark,
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // March 2025 Section
          _buildTransactionSection(
            title: 'March 2025',
            transactions: _getMarchTransactions(),
            isDark: isDark,
          ),
        ],
      ),
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
        // Section Header
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
            const Icon(
              M3Icons.helpOutline,
              color: AppColorSchemes.greysMidGrey,
              size: 24,
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Transaction List
        ...transactions
            .map((transaction) => _buildTransactionItem(transaction, isDark)),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionData transaction, bool isDark) {
    return InkWell(
      onTap: () {
        context.go(
          '/transaction-detail',
          extra: {
            'title': transaction.merchant,
            'subtitle': transaction.date,
            'amount': transaction.amount,
            'originalAmount': transaction.originalAmount
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          children: [
            // 12px zusätzlicher Abstand oben
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Top-alignment für Zahlen
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
                      const SizedBox(height: 5),
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
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _isNumbersVisible
                        ? Text(
                            context.withAppCurrency(transaction.amount),
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                              context.withAppCurrency(transaction.originalAmount),
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
      ),
    );
  }

  // Sample transaction data
  List<TransactionData> _getOpenTransactions() {
    return [
      TransactionData(
        merchant: 'Decathlon Schweiz',
        amount: 'CHF –323.30',
        date: '29. April | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Migros Stadelhofen',
        amount: 'CHF –4\'323.30',
        date: '29. April | 8:12 pm',
        originalAmount: '',
      ),
    ];
  }

  List<TransactionData> _getPastTransactions() {
    return [
      TransactionData(
        merchant: 'Migros Limmatplatz, Zurich\nRetro LTD',
        amount: 'CHF –53.30',
        date: '25. April | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'SBB Easyride',
        amount: 'CHF –123.30',
        date: '25. April | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Twint Martin Wenger',
        amount: 'CHF –23.30',
        date: '15. April | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Amazon Germany',
        amount: 'CHF –123.30',
        date: '14. April | 8:12 pm',
        originalAmount: 'EUR –125.80',
      ),
      TransactionData(
        merchant: 'IKEA Schweiz',
        amount: 'CHF –2\'323.30',
        date: '13. April | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'IKEA Schweiz',
        amount: 'CHF –1\'323.30',
        date: '11. April | 8:12 pm',
        originalAmount: '',
      ),
    ];
  }

  List<TransactionData> _getMarchTransactions() {
    return [
      TransactionData(
        merchant: 'Dosenbach-Ochsner',
        amount: 'CHF –3\'323.30',
        date: '13. March | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Hornbach Schweiz',
        amount: 'CHF –8\'323.30',
        date: 'March | 8:12 pm',
        originalAmount: '',
      ),
      TransactionData(
        merchant: 'Visilab Spreitenbach',
        amount: 'CHF –9\'323.30',
        date: 'March | 8:12 pm',
        originalAmount: '',
      ),
    ];
  }

  void _showPayBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;
    final handleColor = isDark
        ? AppColorSchemes.greysMidGrey
        : AppColorSchemes.greysLightGrey;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Options with padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBottomSheetOption(
                      context: context,
                      icon: M3Icons.qrCodeScanner,
                      title: 'Scan invoice',
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/payments/qr-scan');
                      },
                      isDark: isDark,
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    _buildBottomSheetOption(
                      context: context,
                      icon: Icons.add,
                      title: 'Create payment',
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/payments/new-payment');
                      },
                      isDark: isDark,
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    _buildBottomSheetOption(
                      context: context,
                      icon: Icons.swap_horiz,
                      title: 'Create account transfer',
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/payments/account-transfer');
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              
              // Bottom padding for safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final cardBackgroundColor = isDark
        ? AppColorSchemes.darkCardBackground
        : Colors.white;
    final iconAndTextColor = isDark
        ? Colors.white
        : const Color(0xFF333333);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                icon,
                color: iconAndTextColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  color: iconAndTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Preview Content
  Widget _buildPreviewContent(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          _buildAccountPreviewGraph(isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildPreviewTransactionList(isDark),
        ],
      ),
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
      width: 360,
      child: Stack(
        children: [
          // Y-axis with labels
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: isDark
                          ? AppColorSchemes.darkCardBackground
                          : AppColorSchemes.greysLightGrey,
                    ),
                  ],
                ),
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
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: isDark
                          ? AppColorSchemes.darkCardBackground
                          : AppColorSchemes.greysLightGrey,
                    ),
                  ],
                ),
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
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: isDark
                          ? AppColorSchemes.darkCardBackground
                          : AppColorSchemes.greysLightGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bars positioned from bottom
          Positioned(
            bottom: 0,
            left: 100,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBar(0, 80),
                _buildBar(1, 148),
                _buildBar(2, 95),
                _buildBar(3, 110),
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
                'May',
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

  Widget _buildPreviewTransactionList(bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildTransactionSection(
          title: 'May 2025',
          transactions: _getMayTransactions(),
          isDark: isDark,
        ),
        const SizedBox(height: 24),
        _buildTransactionSection(
          title: 'June 2025',
          transactions: _getJuneTransactions(),
          isDark: isDark,
        ),
      ],
    );
  }

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

class TransactionData {
  final String merchant;
  final String amount;
  final String date;
  final String originalAmount;

  TransactionData({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.originalAmount,
  });
}
