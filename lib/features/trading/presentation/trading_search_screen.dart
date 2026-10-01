import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/bottom_sheets/date_filter_sheet.dart';
import '../../../ui/components/bottom_sheets/order_type_filter_sheet.dart';
import '../../../ui/components/bottom_sheets/trading_status_filter_sheet.dart';

/// Trading Search Screen
///
/// Search screen for filtering and searching pending orders
class TradingSearchScreen extends StatefulWidget {
  const TradingSearchScreen({super.key});

  @override
  State<TradingSearchScreen> createState() => _TradingSearchScreenState();
}

class _TradingSearchScreenState extends State<TradingSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedFilters = {};
  String? _selectedOrderType;
  String? _selectedDateRange;
  String? _selectedStatus;

  final List<String> _filterOptions = ['Date', 'Order type', 'Status'];

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
    if (filter == 'Date') {
      _showDateFilterSheet();
    } else if (filter == 'Order type') {
      _showOrderTypeFilterSheet();
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

  void _showOrderTypeFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: OrderTypeFilterSheet(
          selectedOrderType: _selectedOrderType ?? '',
          onOrderTypeSelected: (orderType) {
            setState(() {
              _selectedOrderType = orderType;
            });
          },
        ),
      ),
    );
  }

  void _clearOrderTypeFilter() {
    setState(() {
      _selectedOrderType = null;
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
        child: TradingStatusFilterSheet(
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

  List<_TradingPositionItem> _filterPendingOrders() {
    List<_TradingPositionItem> allOrders = _getPendingOrders();

    var filtered = allOrders;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((order) {
        return order.title.toLowerCase().contains(query) ||
            order.subtitle.toLowerCase().contains(query) ||
            order.amount.toLowerCase().contains(query) ||
            order.percentage.toLowerCase().contains(query);
      }).toList();
    }

    // Apply filters
    if (_selectedOrderType != null) {
      filtered = filtered.where((order) {
        // Extract order type from subtitle (format: "Buy | USD 200.01 | 30.09.2025")
        final parts = order.subtitle.split('|');
        if (parts.isNotEmpty) {
          final orderType = parts[0].trim();
          return orderType.toLowerCase() == _selectedOrderType!.toLowerCase();
        }
        return false;
      }).toList();
    }

    if (_selectedDateRange != null) {
      // Filter by date range
      filtered = filtered.where((order) {
        // Extract date from subtitle (format: "Buy | USD 200.01 | 30.09.2025")
        final parts = order.subtitle.split('|');
        if (parts.length >= 3) {
          final dateStr = parts[2].trim();
          return dateStr.toLowerCase().contains(_selectedDateRange!.toLowerCase());
        }
        return false;
      }).toList();
    }

    if (_selectedStatus != null && _selectedStatus != 'All') {
      filtered = filtered.where((order) {
        return order.percentage.toLowerCase().contains(_selectedStatus!.toLowerCase());
      }).toList();
    }

    return filtered;
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

              // Order List
              Expanded(
                child: _buildOrderList(isDark),
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
                        : const AppBottomNavigation(activeRoute: '/more'),
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
                'Trading',
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
          borderRadius: BorderRadius.circular(8),
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
            hintText: 'Symbol, ISIN, etc.',
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
          final isOrderTypeFilter = filter == 'Order type';
          final isDateFilter = filter == 'Date';
          final isStatusFilter = filter == 'Status';
          
          if (isOrderTypeFilter && _selectedOrderType != null) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < _filterOptions.length - 1 ? 8 : 0,
              ),
              child: _buildOrderTypeTag(isDark),
            );
          }
          
          if (isDateFilter && _selectedDateRange != null) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < _filterOptions.length - 1 ? 8 : 0,
              ),
              child: _buildDateTag(isDark),
            );
          }
          
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

  Widget _buildOrderTypeTag(bool isDark) {
    return GestureDetector(
      onTap: _showOrderTypeFilterSheet,
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
              _selectedOrderType ?? '',
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
                _clearOrderTypeFilter();
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

  Widget _buildOrderList(bool isDark) {
    final filteredOrders = _filterPendingOrders();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
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
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderItem(filteredOrders[index], isDark);
      },
    );
  }

  Widget _buildOrderItem(_TradingPositionItem order, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const percentageColor = subtitleColor;

    // Extract order type from subtitle (Buy or Sell)
    final orderType = order.subtitle.split('|').first.trim();

    return InkWell(
      onTap: () {
        context.push('/trading/pending-order-detail', extra: {
          'title': order.title,
          'amount': order.amount,
          'subtitle': 'MMM | Valor 998421817 ISIN CH998421817',
          'orderType': orderType,
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.title,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.subtitle,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.amount,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.percentage,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: percentageColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Pending Orders data (from TradingScreen)
  List<_TradingPositionItem> _getPendingOrders() {
    return [
      _TradingPositionItem(
        title: 'Akt. 3M USD 0.01 (998421819)',
        subtitle: 'Buy | USD 200.01 | 30.09.2025',
        amount: '99.00%',
        percentage: 'recorded',
      ),
      _TradingPositionItem(
        title: 'Akt. The Swatch Group (12255515)',
        subtitle: 'Buy | 11 Pcs. | 02.09.2025',
        amount: 'EUR 360.29',
        percentage: 'recorded',
      ),
      _TradingPositionItem(
        title: 'Akt. The Swatch Group (12255515)',
        subtitle: 'Buy | 20 Pcs. | 01.09.2025',
        amount: 'EUR 360.29',
        percentage: 'placed',
      ),
      _TradingPositionItem(
        title: 'Akt. The Swatch Group (12255515)',
        subtitle: 'Buy | 20 Pcs. | 01.09.2025',
        amount: 'EUR 360.29',
        percentage: 'placed',
      ),
    ];
  }
}

class _TradingPositionItem {
  final String title;
  final String subtitle;
  final String amount;
  final String percentage;
  
  _TradingPositionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.percentage,
  });
}
