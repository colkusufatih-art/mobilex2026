import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../core/account/account_notifier.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../app.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class PensionDetailScreen extends StatefulWidget {
  final String title;
  final String amount;

  const PensionDetailScreen({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  State<PensionDetailScreen> createState() => _PensionDetailScreenState();
}

class _PensionDetailScreenState extends State<PensionDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  late AccountNotifier _accountNotifier;

  @override
  void initState() {
    super.initState();
    _accountNotifier = context.accountNotifier!;
    _accountNotifier.addListener(_onAliasChanged);
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _accountNotifier.removeListener(_onAliasChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onAliasChanged() {
    setState(() {
      // Rebuild when alias changes
    });
  }

  String get _currentAlias {
    return _accountNotifier.getAlias(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(isDark),
              
              // Transaction Header
              _buildTransactionHeader(context, isDark),
              
              const SizedBox(height: 32),
              
              // Tabbar
              _buildTabbar(isDark),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTransactionsTab(isDark),
                  ],
                ),
              ),
              
              // Bottom Navigation
              const AppBottomNavigation(activeRoute: '/assets'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.go('/assets'),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                M3Icons.arrowBack,
                color: textColor,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              context.push('/pension-details', extra: {
                'title': widget.title,
                'amount': widget.amount,
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Details',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final activeColor = AppColorSchemes.primaryDarkYellow;
    final currency = context.appCurrency;
    final displayAmount = context.withAppCurrency(widget.amount);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Subtitle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentAlias,
                  style: GoogleFonts.openSans(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Amount and Available Amount
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Amount
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$currency ',
                        style: GoogleFonts.openSans(
                          color: activeColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: displayAmount.replaceFirst('$currency ', ''),
                        style: GoogleFonts.openSans(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
                
                const SizedBox(height: 2),
                
                // Available Amount
                Text(
                  context.withAppCurrency('Available amount CHF 0.00'),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.openSans(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 2.19,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabbar(bool isDark) {
    final activeColor = AppColorSchemes.primaryDarkYellow;
    final inactiveColor = AppColorSchemes.getTextColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);
    final dividerColor = isDark
        ? AppColorSchemes.darkCardBackground
        : AppColorSchemes.greysLightGrey;
    final tabBarBackgroundColor = isDark
        ? const Color(0xFF2B2B2B)
        : const Color(0xFFF6F5FA);
    
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 50),
          color: tabBarBackgroundColor,
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: 8,
          ),
          child: Row(
            children: [
              // Transaktionen tab
              InkWell(
                onTap: () {
                  _tabController.animateTo(0);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions',
                          style: GoogleFonts.openSans(
                            color: _selectedTabIndex == 0
                                ? activeColor
                                : inactiveColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        if (_selectedTabIndex == 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 2,
                            decoration: BoxDecoration(
                              color: activeColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Search button
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  // Handle search
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColorSchemes.darkCardBackground
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: textColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: dividerColor,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildTransactionsTab(bool isDark) {
    const subtitleColor = AppColorSchemes.greysMidGrey;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Transactions recorded section
          Text(
            'Transactions recorded',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: subtitleColor,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Transaction items
          _buildTransactionItem(
            title: 'Payment 152',
            date: '29. June',
            amount: 'CHF 150.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 151',
            date: '25. June',
            amount: 'CHF 140.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 150',
            date: '25. June',
            amount: 'CHF 500.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 149',
            date: '01. June ',
            amount: 'CHF 300.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 148',
            date: '01. June ',
            amount: 'CHF 300.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 36),
          
          // May 2025 section
          Text(
            'May 2025',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: subtitleColor,
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 147',
            date: '29. May ',
            amount: 'CHF 7\'500.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 146',
            date: '25. May ',
            amount: 'CHF 200.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 145',
            date: '25. May ',
            amount: 'CHF 500.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 144',
            date: '01. May ',
            amount: 'CHF 800.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 24),
          
          _buildTransactionItem(
            title: 'Payment 143',
            date: '01. May',
            amount: 'CHF 300.00',
            isDark: isDark,
            context: context,
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required bool isDark,
    required BuildContext context,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    
    return InkWell(
      onTap: () {
        context.push('/pension-transaction-detail', extra: {
          'title': title,
          'date': date,
          'amount': amount,
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

}

