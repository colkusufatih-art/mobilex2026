import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/bottom_sheets/recipient_account_sheet.dart';
import '../../../ui/components/bottom_sheets/amount_filter_sheet.dart';
import '../../../ui/components/bottom_sheets/date_filter_sheet.dart';
import '../../../ui/components/bottom_sheets/status_filter_sheet.dart';

/// Account Transactions Search Screen
///
/// Search screen for filtering and searching transactions
class AccountTransactionsSearchScreen extends StatefulWidget {
  const AccountTransactionsSearchScreen({super.key});

  @override
  State<AccountTransactionsSearchScreen> createState() =>
      _AccountTransactionsSearchScreenState();
}

class _AccountTransactionsSearchScreenState
    extends State<AccountTransactionsSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedFilters = {};
  String? _selectedAccountFilter;
  String? _selectedAmountRange;
  String? _selectedDateRange;
  String? _selectedStatus;

  final List<String> _filterOptions = ['Account', 'Amount', 'Date', 'Status'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _toggleFilter(String filter) {
    if (filter == 'Account') {
      _showAccountSelectionSheet();
    } else if (filter == 'Amount') {
      _showAmountFilterSheet();
    } else if (filter == 'Date') {
      _showDateFilterSheet();
    } else if (filter == 'Status') {
      _showStatusFilterSheet();
    } else {
      setState(() {
        if (_selectedFilters.contains(filter)) {
          _selectedFilters.remove(filter);
        } else {
          _selectedFilters.add(filter);
        }
      });
    }
  }

  void _showAccountSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RecipientAccountSheet(
          selectedAccount: _selectedAccountFilter ?? '',
          onAccountSelected: (accountFullValue) {
            // Extract the account holder name (first line before \n)
            final accountHolderName = accountFullValue.split('\n').first;
            setState(() {
              _selectedAccountFilter = accountHolderName;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _clearAccountFilter() {
    setState(() {
      _selectedAccountFilter = null;
    });
  }

  void _showAmountFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AmountFilterSheet(
          selectedAmountRange: _selectedAmountRange ?? '',
          onAmountRangeSelected: (range) {
            setState(() {
              _selectedAmountRange = range.isEmpty ? null : range;
            });
          },
        ),
      ),
    );
  }

  void _clearAmountFilter() {
    setState(() {
      _selectedAmountRange = null;
    });
  }

  void _showDateFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DateFilterSheet(
          selectedDateRange: _selectedDateRange ?? '',
          onDateRangeSelected: (range) {
            setState(() {
              _selectedDateRange = range.isEmpty ? null : range;
            });
          },
        ),
      ),
    );
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
    });
  }

  void _showStatusFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatusFilterSheet(
          selectedStatus: _selectedStatus ?? '',
          onStatusSelected: (status) {
            setState(() {
              _selectedStatus = status;
            });
          },
        ),
      ),
    );
  }

  void _clearStatusFilter() {
    setState(() {
      _selectedStatus = null;
    });
  }

  List<TransactionData> _filterTransactions() {
    List<TransactionData> allTransactions = [
      ..._getOpenTransactions(),
      ..._getPastTransactions(),
      ..._getMarchTransactions(),
    ];

    if (_searchQuery.isEmpty) {
      return allTransactions;
    }

    final query = _searchQuery.toLowerCase();
    return allTransactions.where((transaction) {
      return transaction.merchant.toLowerCase().contains(query) ||
          transaction.amount.toLowerCase().contains(query) ||
          transaction.date.toLowerCase().contains(query);
    }).toList();
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Search Field
              _buildSearchField(isDark),

              // Filter Chips
              _buildFilterChips(isDark),

              const SizedBox(height: 24),

              // Transaction List
              Expanded(
                child: _buildTransactionList(isDark),
              ),

              // Bottom Navigation
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final isKeyboardVisible = bottomInset > 0;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isKeyboardVisible ? 0 : 1,
                    child: isKeyboardVisible
                        ? const SizedBox.shrink()
                        : const AppBottomNavigation(activeRoute: '/assets'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Transactions',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => context.pop(),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      M3Icons.close,
                      color: textColor,
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

  Widget _buildSearchField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColorSchemes.getCardBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.getTextColor(isDark),
          ),
          decoration: InputDecoration(
            hintText: 'Recipient, IBAN, etc.',
            hintStyle: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColorSchemes.greysMidGrey,
            ),
            prefixIcon: const Icon(
              M3Icons.search,
              color: AppColorSchemes.greysMidGrey,
              size: 24,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      M3Icons.close,
                      color: AppColorSchemes.greysMidGrey,
                      size: 24,
                    ),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilters.contains(filter);
          final isAccountFilter = filter == 'Account';
          final isAmountFilter = filter == 'Amount';
          final isDateFilter = filter == 'Date';
          final isStatusFilter = filter == 'Status';
          
          // Show account tag if account is selected, otherwise show filter chip
          if (isAccountFilter && _selectedAccountFilter != null) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < _filterOptions.length - 1 ? 8 : 0,
              ),
              child: _buildAccountTag(isDark),
            );
          }
          
          // Show amount tag if amount range is selected, otherwise show filter chip
          if (isAmountFilter && _selectedAmountRange != null) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < _filterOptions.length - 1 ? 8 : 0,
              ),
              child: _buildAmountTag(isDark),
            );
          }
          
          // Show date tag if date range is selected, otherwise show filter chip
          if (isDateFilter && _selectedDateRange != null) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < _filterOptions.length - 1 ? 8 : 0,
              ),
              child: _buildDateTag(isDark),
            );
          }
          
          // Show status tag if status is selected, otherwise show filter chip
          if (isStatusFilter && _selectedStatus != null) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < _filterOptions.length - 1 ? 8 : 0,
              ),
              child: _buildStatusTag(isDark),
            );
          }
          
          return Padding(
            padding: EdgeInsets.only(
              right: index < _filterOptions.length - 1 ? 8 : 0,
            ),
            child: _buildFilterChip(filter, isSelected, isDark),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return InkWell(
      onTap: () => _toggleFilter(label),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColorSchemes.getCardBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorSchemes.getTextColor(isDark),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              M3Icons.keyboardArrowDown,
              size: 18,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTag(bool isDark) {
    return GestureDetector(
      onTap: _showAccountSelectionSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedAccountFilter ?? '',
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorSchemes.getTextColor(isDark),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _clearAccountFilter();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  M3Icons.close,
                  size: 18,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountTag(bool isDark) {
    return GestureDetector(
      onTap: _showAmountFilterSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedAmountRange ?? '',
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorSchemes.getTextColor(isDark),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _clearAmountFilter();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  M3Icons.close,
                  size: 18,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTag(bool isDark) {
    return GestureDetector(
      onTap: _showDateFilterSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedDateRange ?? '',
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorSchemes.getTextColor(isDark),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _clearDateFilter();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  M3Icons.close,
                  size: 18,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(bool isDark) {
    return GestureDetector(
      onTap: _showStatusFilterSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedStatus ?? '',
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorSchemes.getTextColor(isDark),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _clearStatusFilter();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  M3Icons.close,
                  size: 18,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(bool isDark) {
    final filteredTransactions = _filterTransactions();

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.greysMidGrey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionItem(filteredTransactions[index], isDark);
      },
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
            'originalAmount': transaction.originalAmount,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
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
                          fontWeight: FontWeight.w700,
                          color: AppColorSchemes.getTextColor(isDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.date,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
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
                      transaction.amount,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColorSchemes.getTextColor(isDark),
                      ),
                    ),
                    if (transaction.originalAmount.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        transaction.originalAmount,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColorSchemes.greysMidGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
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

  // Sample transaction data (same as in AccountTransactionsScreen)
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

