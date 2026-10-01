import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  int _selectedTabIndex = 0; // 0 = Symbol / Valor / ISIN, 1 = Title
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Stock data from Figma + Major World Indices
  static const _stocks = [
    _StockItem(
      title: 'Swiss Re AG',
      valorIsin: '126881568 | CH0126881561',
      amount: 'CHF 107.20',
    ),
    _StockItem(
      title: 'Swisscom AG',
      valorIsin: '455881560 | CH01268889181',
      amount: 'CHF 99.12',
    ),
    _StockItem(
      title: 'Tesla',
      valorIsin: '11448018 | US88160R1014',
      amount: 'USD 244.10',
    ),
    _StockItem(
      title: 'Amazon',
      valorIsin: '645156 | US0231351067',
      amount: 'USD 325.99',
    ),
    _StockItem(
      title: 'Apple Inc.',
      valorIsin: '908440 | US0378331005',
      amount: 'USD 107.99',
    ),
    // Major World Indices
    _StockItem(
      title: 'S&P 500',
      valorIsin: 'SPX | US78378X1072',
      amount: 'USD 6\'819.27',
    ),
    _StockItem(
      title: 'US Composite Index (Nasdaq)',
      valorIsin: 'IXIC | US6311011026',
      amount: 'USD 23\'162.60',
    ),
    _StockItem(
      title: 'Dow Jones Industrial Average',
      valorIsin: 'DJI | US2605661048',
      amount: 'USD 48\'452.17',
    ),
    _StockItem(
      title: 'CBOE Volatility Index',
      valorIsin: 'VIX | US12498A1016',
      amount: 'USD 16.47',
    ),
    _StockItem(
      title: 'S&P/TSX Composite',
      valorIsin: 'TSX | CA82509L1076',
      amount: 'CAD 31\'480.64',
    ),
    _StockItem(
      title: 'UK 100 Index (FTSE)',
      valorIsin: 'UKX | GB0001383545',
      amount: 'GBP 9\'831.89',
    ),
    _StockItem(
      title: 'DAX Index',
      valorIsin: 'DAX | DE0008469008',
      amount: 'EUR 24\'185.47',
    ),
    _StockItem(
      title: 'CAC 40 Index',
      valorIsin: 'PX1 | FR0003500008',
      amount: 'EUR 8\'136.07',
    ),
    _StockItem(
      title: 'FTSE MIB Index',
      valorIsin: 'FTMIB | IT0003465736',
      amount: 'EUR 44\'297.55',
    ),
    _StockItem(
      title: 'Nikkei 225',
      valorIsin: 'NI225 | JP9010C00002',
      amount: 'JPY 49\'571.50',
    ),
    _StockItem(
      title: 'KOSPI Index',
      valorIsin: 'KOSPI | KR7069500007',
      amount: 'KRW 4\'060.24',
    ),
    _StockItem(
      title: 'SSE Composite Index',
      valorIsin: '000001 | CNM0000001Y0',
      amount: 'CNY 3\'881.75',
    ),
    _StockItem(
      title: 'Euro Stoxx 50',
      valorIsin: 'SX5E | EU0009658145',
      amount: 'EUR 5\'745.87',
    ),
    _StockItem(
      title: 'Nifty 50 Index',
      valorIsin: 'NIFTY | INE009A01021',
      amount: 'INR 25\'929.15',
    ),
    _StockItem(
      title: 'S&P BSE Sensex',
      valorIsin: 'SENSEX | INE001A01036',
      amount: 'INR 84\'889.45',
    ),
    _StockItem(
      title: 'Bovespa Index',
      valorIsin: 'IBOV | BRIBOVINDM18',
      amount: 'BRL 162\'481.74',
    ),
  ];

  List<_StockItem> get _filteredStocks {
    if (_searchQuery.trim().isEmpty) {
      return [];
    }
    final normalizedQuery = _searchQuery.toLowerCase();

    if (_selectedTabIndex == 0) {
      // Search by Symbol / Valor / ISIN
      return _stocks.where((stock) {
        final valorIsin = stock.valorIsin.toLowerCase();
        return valorIsin.contains(normalizedQuery);
      }).toList();
    } else {
      // Search by Title
      return _stocks.where((stock) {
        final title = stock.title.toLowerCase();
        return title.contains(normalizedQuery);
      }).toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
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
              _ProgressHeader(isDark: isDark, title: 'Buy'),
              const SizedBox(height: 16),
              // Segmented Control Tabbar
              _buildSegmentedControl(isDark),
              const SizedBox(height: 16),
              // Search Field
              _SearchField(
                isDark: isDark,
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: _selectedTabIndex == 0
                    ? 'Symbol / Valor ISIN'
                    : 'Title',
              ),
              const SizedBox(height: 16),
              // Content Area
              Expanded(
                child: _buildContent(isDark),
              ),
              const AppBottomNavigation(activeRoute: '/more'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(bool isDark) {
    final containerColor =
        isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final selectedBgColor = AppColorSchemes.primaryDarkYellow;
    final unselectedTextColor =
        isDark ? Colors.white : AppColorSchemes.greysDarkGrey;
    final selectedTextColor = AppColorSchemes.greysDarkGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
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
                    _selectedTabIndex = 0;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: Container(
                  height: 37,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 0
                        ? selectedBgColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'Symbol / Valor / ISIN',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedTabIndex == 0
                            ? selectedTextColor
                            : unselectedTextColor,
                        letterSpacing: 0.25,
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
                    _selectedTabIndex = 1;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: Container(
                  height: 37,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 1
                        ? selectedBgColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'Title',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedTabIndex == 1
                            ? selectedTextColor
                            : unselectedTextColor,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final filteredList = _filteredStocks;

    if (_searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    if (filteredList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          'No results found',
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.greysMidGrey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final stock = filteredList[index];
        return _StockListItem(
          stock: stock,
          isDark: isDark,
        );
      },
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final bool isDark;
  final String title;
  const _ProgressHeader({required this.isDark, required this.title});

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final backgroundColor =
        isDark ? AppColorSchemes.darkBackground : AppColorSchemes.lightBackground;
    final inactiveDividerColor =
        isDark ? AppColorSchemes.greysDarkGrey : AppColorSchemes.greysLightGrey;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back,
                color: textColor,
                onTap: () => context.pop(),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              _HeaderIconButton(
                icon: Icons.close,
                color: textColor,
                onTap: () => context.go('/trading'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
                ),
                Expanded(
                  child: Container(color: inactiveDividerColor),
                ),
                Expanded(
                  child: Container(color: inactiveDividerColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const _SearchField({
    required this.isDark,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColorSchemes.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        height: 56,
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          cursorColor: AppColorSchemes.primaryDarkYellow,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            hintText: hintText,
            hintStyle: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColorSchemes.greysMidGrey,
            ),
            prefixIcon: const Icon(
              M3Icons.search,
              color: AppColorSchemes.greysMidGrey,
            ),
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    icon: Icon(
                      Icons.close,
                      color: textColor,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _StockListItem extends StatelessWidget {
  final _StockItem stock;
  final bool isDark;

  const _StockListItem({
    required this.stock,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return InkWell(
      onTap: () {
        context.push('/trading/buy-position-detail', extra: {
          'title': stock.title,
          'amount': stock.amount,
          'subtitle': stock.valorIsin,
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.title,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stock.valorIsin,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColorSchemes.greysMidGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              stock.amount,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockItem {
  final String title;
  final String valorIsin;
  final String amount;

  const _StockItem({
    required this.title,
    required this.valorIsin,
    required this.amount,
  });
}
