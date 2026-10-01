import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/currency/currency_scope.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/radius.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../core/account/account_notifier.dart';
import '../../../app.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/bottom_sheets/sorting_selection_sheet.dart';

class PortfolioDetailScreen extends StatefulWidget {
  final String title;
  final String amount;

  const PortfolioDetailScreen({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  State<PortfolioDetailScreen> createState() => _PortfolioDetailScreenState();
}

class _PortfolioDetailScreenState extends State<PortfolioDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isTabBarVisible = false;
  late AccountNotifier _accountNotifier;
  String _selectedPeriod = 'Monthly'; // 'Monthly' or 'Yearly'
  int _selectedBarIndex =
      2; // Default active bar (the +6.5% bar between Apr and Jun)
  late AnimationController _allocationAnimationController;
  late Animation<double> _allocationAnimation;
  String _selectedSorting = 'Investmentsgroups'; // Selected sorting option

  // Bar data arrays - Amounts, months, percentages, and CHF amounts for each bar
  final List<String> _barAmounts = [
    "110'987.20", // Bar 0
    "106'193.33", // Bar 1
    "122'193.54", // Bar 2
    "109'231.45", // Bar 3
    "123'193.00", // Bar 4
    "109'784.99", // Bar 5
  ];

  final List<String> _barMonths = [
    'Apr', // Bar 0
    'Apr', // Bar 1
    'May', // Bar 2
    'May', // Bar 3
    'Jun', // Bar 4
    'Jul', // Bar 5
  ];

  final List<String> _barPercentages = [
    '-4.66%', // Bar 0
    '-7.20%', // Bar 1
    '+4.66%', // Bar 2
    '-3.02%', // Bar 3
    '+4.34%', // Bar 4
    '-2.69%', // Bar 5
  ];

  final List<String> _barChfAmounts = [
    "-13'163.80", // Bar 0
    "-16'163.80", // Bar 1
    "+13'163.80", // Bar 2
    "-4'068.34", // Bar 3
    "+8'163.80", // Bar 4
    "-4'068.34", // Bar 5
  ];

  final List<bool> _barIsPositive = [
    false, // Bar 0
    false, // Bar 1
    true, // Bar 2
    false, // Bar 3
    true, // Bar 4
    false, // Bar 5
  ];

  // Yearly data arrays (for 4 bars: 2022, 2023, 2024, 2025)
  final List<String> _yearlyAmounts = [
    "122'193.00", // Bar 0 (2022)
    "106'193.33", // Bar 1 (2023)
    "130'193.54", // Bar 2 (2024)
    "115'193.00", // Bar 3 (2025)
  ];

  final List<String> _yearlyYears = [
    '2022', // Bar 0
    '2023', // Bar 1
    '2024', // Bar 2
    '2025', // Bar 3
  ];

  final List<String> _yearlyPercentages = [
    '-2.50%', // Bar 0 (2022) - negativ
    '+4.66%', // Bar 1 (2023) - positiv
    '-2.50%', // Bar 2 (2024) - negativ
    '+2.00%', // Bar 3 (2025) - positiv
  ];

  final List<String> _yearlyChfAmounts = [
    "-3'163.08", // Bar 0 (2022) - negativ
    "+13'163.08", // Bar 1 (2023) - positiv
    "-3'163.08", // Bar 2 (2024) - negativ
    "+2'163.08", // Bar 3 (2025) - positiv
  ];

  final List<bool> _yearlyIsPositive = [
    false, // Bar 0 (2022) - negativ
    true, // Bar 1 (2023) - positiv
    false, // Bar 2 (2024) - negativ
    true, // Bar 3 (2025) - positiv
  ];

  @override
  void initState() {
    super.initState();
    _accountNotifier = context.accountNotifier!;
    _accountNotifier.addListener(_onAliasChanged);
    _tabController = TabController(length: 3, vsync: this);
    // Initialize allocation animation first
    _allocationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _allocationAnimation = CurvedAnimation(
      parent: _allocationAnimationController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
    
    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex != _selectedTabIndex) {
        setState(() {
          _selectedTabIndex = newIndex;
        });
        // Start animation when Allocation tab is selected
        if (_selectedTabIndex == 2) {
          _allocationAnimationController.reset();
          _allocationAnimationController.forward();
        } else {
          // Reset animation when leaving Allocation tab
          _allocationAnimationController.reset();
        }
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _accountNotifier.removeListener(_onAliasChanged);
    _tabController.dispose();
    _scrollController.dispose();
    _allocationAnimationController.dispose();
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

  void _onScroll() {
    // Calculate if tabbar should be visible (after Transaction Header + Buttons scroll out of view)
    final threshold = _getTransactionHeaderHeight() + 32 + _getSecondaryButtonsHeight();
    final shouldBeVisible = _scrollController.offset >= threshold;
    if (shouldBeVisible != _isTabBarVisible) {
      setState(() {
        _isTabBarVisible = shouldBeVisible;
      });
    }
  }

  double _getHeaderHeight() {
    // Header height (56px) + SafeArea top padding
    return 56.0;
  }

  double _getSecondaryButtonsHeight() {
    // Height of Buy/Sell buttons container (56px)
    return 56.0;
  }

  double _getTransactionHeaderHeight() {
    // Approximate height of transaction header
    // Padding top: 12px
    // Title (28px font * 1.25 height) = ~35px
    // SizedBox: 2px
    // Subtitle (16px font * 2.19 height) = ~35px
    // SizedBox: 32px
    // Amount section: 35px
    // SizedBox: 2px
    // YTD section: ~24px
    // SizedBox: 2px
    // Graph: 8px
    // Total: ~205px
    return 205.0;
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
          child: Stack(
            children: [
              // Scrollable Content
              Column(
                children: [
                  // Header (fixed)
                  _buildHeader(isDark),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Transaction Header (scrollable)
                          _buildTransactionHeader(context, isDark),

                          const SizedBox(height: 32),

                          // Secondary Buttons (Buy/Sell) (scrollable)
                          _buildSecondaryButtons(isDark),

                          const SizedBox(height: 32),

                          // Tabbar (original position, scrollable)
                          _buildTabbar(isDark),

                          const SizedBox(height: 32),

                          // Tab Content - Use a height that accommodates all content
                          // Performance tab: graph (~420px) + section title (~40px) + 8 items (~100px each + 24px padding = ~992px) = ~1452px
                          // Add extra padding for safety
                          SizedBox(
                            height: 2000, // Increased height to accommodate all Performance tab content without overflow
                            child: TabBarView(
                              controller: _tabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildPositionsTab(context, isDark),
                                _buildPerformanceTab(isDark),
                                _buildAllocationTab(context, isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Navigation
                  const AppBottomNavigation(activeRoute: '/assets'),
                ],
              ),

              // Sticky Tabbar (appears when scrolling)
              if (_isTabBarVisible)
                Positioned(
                  top: _getHeaderHeight(),
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 2,
                    color: backgroundColor,
                    child: _buildTabbar(isDark),
                  ),
                ),
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
              context.push('/portfolio-details', extra: {
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
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const positiveColor = Color(0xFF34C759);
    final activeColor = AppColorSchemes.primaryDarkYellow;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Container: Title and Subtitle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 343,
                  child: Text(
                    _currentAlias,
                    style: GoogleFonts.openSans(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 343,
                  child: Text(
                    '771534621502',
                    style: GoogleFonts.openSans(
                      color: subtitleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 2.19,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Second Container: Amount, YTD, and Graph
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Amount
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${context.appCurrency} ',
                                            style: GoogleFonts.openSans(
                                              color: activeColor,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
                                              height: 1.25,
                                            ),
                                          ),
                                          TextSpan(
                                            text: context
                                                .withAppCurrency(
                                                    widget.amount.startsWith('CHF ')
                                                        ? widget.amount
                                                        : 'CHF ${widget.amount}')
                                                .replaceFirst(
                                                    '${context.appCurrency} ', ''),
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 2),

                      // YTD Performance
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'YTD',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.openSans(
                              color: positiveColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 2.19,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: positiveColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${context.appCurrency} +4.66% | ${context.appCurrency} +13\'163.80',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.openSans(
                                color: positiveColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 2.19,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Graph
                      SizedBox(
                        width: 249,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5BC5F2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C3D0),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Container(
                              width: 27,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6155F5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
    final dividerColor = isDark
        ? AppColorSchemes.darkCardBackground
        : AppColorSchemes.greysLightGrey;
    final tabBarBackgroundColor =
        isDark ? const Color(0xFF2B2B2B) : const Color(0xFFF6F5FA);

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 50),
          color: tabBarBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Allocation needs only enough width for the text + padding (smaller)
              const allocationTextWidth =
                  100.0; // Approximate width for "Allocation"
              const allocationWidth = allocationTextWidth + AppSpacing.md;

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Positions tab
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
                              'Positions',
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
                  const SizedBox(width: 32),
                  // Performance tab (center, larger)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: IntrinsicWidth(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Performance',
                                  style: GoogleFonts.openSans(
                                    color: _selectedTabIndex == 1
                                        ? activeColor
                                        : inactiveColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.50,
                                  ),
                                ),
                                if (_selectedTabIndex == 1) ...[
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
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Allocation tab (right, smaller, aligned with Sell button)
                  SizedBox(
                    width: allocationWidth,
                    child: InkWell(
                      onTap: () {
                        _tabController.animateTo(2);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 8,
                          right: AppSpacing.md,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IntrinsicWidth(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Allocation',
                                  style: GoogleFonts.openSans(
                                    color: _selectedTabIndex == 2
                                        ? activeColor
                                        : inactiveColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.50,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_selectedTabIndex == 2) ...[
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
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: Divider(
            color: dividerColor,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButtons(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () {
                context.push('/trading/buy');
              },
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: textColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Buy',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () {
                context.push('/trading/sell');
              },
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: textColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sell',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsTab(BuildContext context, bool isDark) {
    // Determine amounts based on portfolio
    final bool is1502 = widget.title == '1502 CHF';

    final String bondsTotal = is1502 ? 'CHF 20\'000.00' : 'CHF 3\'400.00';
    final String bondsPosition1 = is1502 ? 'CHF 12\'000.00' : 'CHF 1\'758.32';
    final String bondsPosition2 = is1502 ? 'CHF 8\'000.00' : 'CHF 1\'641.68';

    final String sharesTotal = is1502 ? 'CHF 25\'000.00' : 'CHF 6\'198.29';
    final String sharesPosition1 = is1502 ? 'CHF 15\'000.00' : 'CHF 3\'099.15';
    final String sharesPosition2 = is1502 ? 'CHF 10\'000.00' : 'CHF 3\'099.14';

    final String optionsTotal = is1502 ? 'CHF 5\'454.30' : 'CHF 594.71';
    final String optionsPosition1 = is1502 ? 'CHF 5\'454.30' : 'CHF 594.71';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Bonds Section
          _buildSectionTitle(
            context: context,
            title: 'Bonds (01) CLX',
            amount: bondsTotal,
            percentage: '+361.53%',
            isPositive: true,
            color: const Color(0xFF5BC5F2),
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Position 1
          _buildPosition(
            context: context,
            title: '3 % Kanton Zürich 2004 –\n31.07.2026 (1737171)',
            quantity: '100 Pcs.',
            amount: bondsPosition1,
            percentage: '+14.00%',
            isPositive: true,
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Position 2
          _buildPosition(
            context: context,
            title: '10 % GMNA 1987 – 30.09.2027 Pool No...',
            quantity: '2000 Pcs.',
            amount: bondsPosition2,
            percentage: '–9.00%',
            isPositive: false,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Shares Section
          _buildSectionTitle(
            context: context,
            title: 'Shares (02) CLX',
            amount: sharesTotal,
            percentage: '+61.53%',
            isPositive: true,
            color: const Color(0xFF00C3D0),
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Position 3
          _buildPosition(
            context: context,
            title: 'Nam. Akt. Nestlè AG CHF 0.10 (3886335)',
            quantity: '100 Pcs.',
            amount: sharesPosition1,
            percentage: '–21.00%',
            isPositive: false,
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Position 4
          _buildPosition(
            context: context,
            title: 'Tesla Inc.',
            quantity: '1000 Pcs.',
            amount: sharesPosition2,
            percentage: '–14.00%',
            isPositive: false,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Options Section
          _buildSectionTitle(
            context: context,
            title: 'Options (07) CLX',
            amount: optionsTotal,
            percentage: null,
            isPositive: null,
            color: const Color(0xFF6155F5),
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Position 5
          _buildPosition(
            context: context,
            title: 'Put Nestlè Eurex 02.2026 CHF 78.00 ',
            quantity: '5 Pcs.',
            amount: optionsPosition1,
            percentage: null,
            isPositive: null,
            isDark: isDark,
          ),

        ],
      ),
    );
  }

  Widget _buildPerformanceTab(bool isDark) {
    // Content is now scrollable via the outer SingleChildScrollView
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Graph Section
        _buildPerformanceGraph(context, isDark),

        // Performance List
        _buildPerformanceList(context, isDark),
      ],
    );
  }

  Widget _buildPerformanceGraph(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final backgroundColor = isDark ? Colors.transparent : const Color(0xFFF6F5FA);
    const positiveColor = Color(0xFF34C759);
    const negativeColor = Color(0xFFC00024);
    const double maxHeight = 175;

    // Monthly data - bar values as percentages (can be positive or negative)
    // 6 bars total: ~-6.5%, -8%, +6.5%, -4.5%, +3%, -4.5%
    // Bar 3 (index 2) is the active one (dark orange)
    final List<double> monthlyBarValues = [-6.5, -8.0, 6.5, -4.5, 3.0, -4.5];

    // Yearly data - bar values as percentages for 2022-2025
    // 4 bars total: -2.5% (2022), +4.66% (2023), -2.5% (2024), +2.0% (2025)
    final List<double> yearlyBarValues = [-2.5, 4.66, -2.5, 2.0];

    final List<double> barValues =
        _selectedPeriod == 'Yearly' ? yearlyBarValues : monthlyBarValues;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Header - rechtsbündig
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${context.appCurrency} ',
                        style: GoogleFonts.openSans(
                          color: AppColorSchemes.primaryDarkYellow,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.59,
                        ),
                      ),
                      TextSpan(
                        text: ' ${_selectedPeriod == 'Yearly' ? _yearlyAmounts[_selectedBarIndex] : _barAmounts[_selectedBarIndex]}',
                        style: GoogleFonts.openSans(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.59,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColorSchemes.primaryDarkYellow
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedPeriod == 'Yearly' 
                          ? _yearlyYears[_selectedBarIndex]
                          : _barMonths[_selectedBarIndex],
                      textAlign: TextAlign.right,
                      style: GoogleFonts.openSans(
                        color: (_selectedPeriod == 'Yearly' 
                                ? _yearlyIsPositive[_selectedBarIndex]
                                : _barIsPositive[_selectedBarIndex])
                            ? positiveColor
                            : negativeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 2.19,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      (_selectedPeriod == 'Yearly' 
                              ? _yearlyIsPositive[_selectedBarIndex]
                              : _barIsPositive[_selectedBarIndex])
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: (_selectedPeriod == 'Yearly' 
                              ? _yearlyIsPositive[_selectedBarIndex]
                              : _barIsPositive[_selectedBarIndex])
                          ? positiveColor
                          : negativeColor,
                      size: 24,
                    ),
                    Text(
                      '${_selectedPeriod == 'Yearly' ? _yearlyPercentages[_selectedBarIndex] : _barPercentages[_selectedBarIndex]} | ${context.appCurrency} ${_selectedPeriod == 'Yearly' ? _yearlyChfAmounts[_selectedBarIndex] : _barChfAmounts[_selectedBarIndex]}',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.openSans(
                        color: (_selectedPeriod == 'Yearly' 
                                ? _yearlyIsPositive[_selectedBarIndex]
                                : _barIsPositive[_selectedBarIndex])
                            ? positiveColor
                            : negativeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 2.19,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColorSchemes.primaryDarkYellow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Accumulated',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.openSans(
                        color: positiveColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 2.19,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_drop_up,
                      color: positiveColor,
                      size: 24,
                    ),
                    Text(
                      '+4.66%',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.openSans(
                        color: positiveColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 2.19,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Graph with Y-axis labels and bars
          _buildPerformanceGraphChart(isDark, maxHeight, barValues),
          const SizedBox(height: AppSpacing.md),
          // Month/Year labels (X-axis)
          _buildPerformanceMonthLabels(),
          const SizedBox(height: AppSpacing.md),
          // Segmented Control
          _buildPerformanceSegmentedControl(isDark, textColor),
        ],
      ),
    );
  }

  Widget _buildPerformanceGraphChart(
      bool isDark, double maxHeight, List<double> barValues) {
    const double maxPercentage = 8.0; // Maximum percentage value (8%)
    final double yAxisWidth = _selectedPeriod == 'Yearly' ? 70.0 : 80.0;

    return SizedBox(
      height: maxHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Y-axis with labels filling the container
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top label (8%) above divider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '8%',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: const Color(0xFFDADADA),
                    ),
                  ],
                ),
                // Middle label (0%) above divider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0%',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: const Color(0xFFDADADA),
                    ),
                  ],
                ),
                // Bottom label (-8%) above divider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '-8%',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: const Color(0xFFDADADA),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bars positioned from center (0% line)
          Positioned(
            top: 0,
            bottom: 0,
            left: yAxisWidth, // Space for Y-axis labels
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < barValues.length; i++)
                  _buildPerformanceBar(
                      i, barValues[i], maxHeight, maxPercentage, i),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBar(int index, double value, double maxHeight,
      double maxPercentage, int barIndex) {
    final bool isActive = _selectedBarIndex == index;
    final bool isPositive = value >= 0;

    // Calculate bar height based on percentage
    // 8% = half of maxHeight, so value / 8.0 * (maxHeight / 2)
    double barHeight = (value.abs() / maxPercentage) * (maxHeight / 2);

    // Individual height adjustments (as multipliers)
    // Different multipliers for Monthly (6 bars) vs Yearly (3 bars)
    final List<double> heightMultipliers = _selectedPeriod == 'Yearly'
        ? [
            1.0, // Bar 0 (2022): keine Änderung
            1.0, // Bar 1 (2023): keine Änderung
            1.0, // Bar 2 (2024): keine Änderung
          ]
        : [
            0.5, // Bar 0: -50% (auf 50% reduziert)
            0.75, // Bar 1: -25% (auf 75% reduziert)
            1.0, // Bar 2: keine Änderung
            1.0, // Bar 3: keine Änderung
            1.0, // Bar 4: keine Änderung
            1.0, // Bar 5: keine Änderung
          ];

    if (heightMultipliers.length > barIndex) {
      barHeight *= heightMultipliers[barIndex];
    }

    final double zeroLineY = maxHeight / 2;

    // Individual bar offsets (in pixels)
    // Different offsets for Monthly (6 bars) vs Yearly (4 bars)
    final List<double> barOffsets = _selectedPeriod == 'Yearly'
        ? [
            12.0, // Bar 0 (2022): 12px nach unten
            12.0, // Bar 1 (2023): 12px nach unten
            12.0, // Bar 2 (2024): 12px nach unten
            14.0, // Bar 3 (2025): 14px nach unten (2px mehr als die anderen)
          ]
        : [
            13.0, // Bar 0: 13px nach unten
            13.0, // Bar 1: 13px nach unten
            12.0, // Bar 2: 12px nach unten (unverändert)
            13.0, // Bar 3: 13px nach unten
            13.0, // Bar 4: 13px nach unten (vorher 14px, jetzt -1px = höher)
            13.0, // Bar 5: 13px nach unten
          ];

    final double offset =
        barOffsets.length > barIndex ? barOffsets[barIndex] : 0.0;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedBarIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: 32,
        height: maxHeight,
        child: Stack(
          children: [
            // Bar positioned from center (0% line)
            // Positive bars go up from zero line, negative bars go down from zero line
            Positioned(
              top: isPositive
                  ? zeroLineY - barHeight + offset
                  : zeroLineY + offset,
              left: 0,
              right: 0,
              child: Container(
                width: 32,
                height: barHeight,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColorSchemes.primaryDarkYellow
                      : AppColorSchemes.primaryDarkYellow
                          .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMonthLabels() {
    if (_selectedPeriod == 'Yearly') {
      // Yearly labels: 2022, 2023, 2024, 2025 (aligned under bars)
      return Row(
        children: [
          // Spacer for Y-axis labels
          SizedBox(width: _selectedPeriod == 'Yearly' ? 70 : 80),
          // Bar 0: 2022 (centered under bar)
          Expanded(
            child: Center(
              child: Text(
                '2022',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
            ),
          ),
          // Bar 1: 2023 (centered under bar)
          Expanded(
            child: Center(
              child: Text(
                '2023',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
            ),
          ),
          // Bar 2: 2024 (centered under bar)
          Expanded(
            child: Center(
              child: Text(
                '2024',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
            ),
          ),
          // Bar 3: 2025 (centered under bar)
          Expanded(
            child: Center(
              child: Text(
                '2025',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Monthly labels: Apr, May, Jun, Jul
      return Row(
        children: [
          // Spacer for Y-axis labels
          const SizedBox(width: 80),
          // Bar 0: Apr
          Text(
            'Apr',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColorSchemes.greysMidGrey,
            ),
          ),
          const SizedBox(width: 68),
          // Bar 1: May
          Text(
            'May',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColorSchemes.greysMidGrey,
            ),
          ),
          const SizedBox(width: 68),
          // Bar 2: Jun
          Text(
            'Jun',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColorSchemes.greysMidGrey,
            ),
          ),
          const SizedBox(width: 68),
          // Bar 5: Jul (bündig mit letztem Balken)
          Text(
            'Jul',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColorSchemes.greysMidGrey,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPerformanceSegmentedControl(bool isDark, Color textColor) {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColorSchemes.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPeriod = 'Monthly';
                  // Ensure selected bar index is valid for Monthly (0-5)
                  if (_selectedBarIndex > 5) {
                    _selectedBarIndex = 2; // Default to bar 2
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedPeriod == 'Monthly'
                      ? AppColorSchemes.primaryDarkYellow
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'Monthly',
                    style: GoogleFonts.openSans(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.56,
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
                  _selectedPeriod = 'Yearly';
                  // Ensure selected bar index is valid for Yearly (0-3)
                  if (_selectedBarIndex > 3) {
                    _selectedBarIndex = 1; // Default to bar 1 (2023)
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedPeriod == 'Yearly'
                      ? AppColorSchemes.primaryDarkYellow
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'Yearly',
                    style: GoogleFonts.openSans(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.56,
                      letterSpacing: 0.25,
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

  Widget _buildPerformanceList(BuildContext context, bool isDark) {
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    final performanceData = _selectedPeriod == 'Monthly'
        ? _getMonthlyPerformanceData()
        : _getYearlyPerformanceData();

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '2025',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColorSchemes.greysMidGrey,
                  ),
                ),
                const Icon(
                  Icons.help_outline,
                  size: 24,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ],
            ),
          ),

          // Performance Items
          ...performanceData.map((item) => _buildPerformanceItem(
                context: context,
                isDark: isDark,
                date: item['date'] as String,
                subtitle: item['subtitle'] as String,
                amount: item['amount'] as String,
                percentage: item['percentage'] as String,
                change: item['change'] as String,
                isPositive: item['isPositive'] as bool,
                cashflow: item['cashflow'] as String,
                isMonthly: _selectedPeriod == 'Monthly',
              )),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem({
    required BuildContext context,
    required bool isDark,
    required String date,
    required String subtitle,
    required String amount,
    required String percentage,
    required String change,
    required bool isPositive,
    required String cashflow,
    required bool isMonthly,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const positiveColor = Color(0xFF34C759);
    const negativeColor = Color(0xFFC00024);
    final color = isPositive ? positiveColor : negativeColor;

    // Generate subtitle for detail screen based on month or year
    final String detailSubtitle = isMonthly 
        ? _getDetailSubtitleForMonth(date)
        : _getDetailSubtitleForYear(date);

    Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColorSchemes.greysMidGrey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.withAppCurrency(amount),
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: color,
                        size: 24,
                      ),
                      Text(
                        '$percentage | ${context.withAppCurrency(change)}',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: color,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.withAppCurrency(cashflow),
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return InkWell(
      onTap: () {
        final String detailTitle = isMonthly 
            ? '2025'
            : _getDetailTitleForYear(date);
        
        context.push('/performance-detail', extra: {
          'title': detailTitle,
          'subtitle': detailSubtitle,
          'amount': amount,
          'percentage': percentage,
          'change': change,
          'isPositive': isPositive,
        });
      },
      child: content,
    );
  }

  String _getDetailSubtitleForMonth(String date) {
    switch (date) {
      case '31.August':
        return '1. Jan. - 31. August 2025';
      case 'July':
        return '1. Jan. - July 2025';
      case 'June':
        return '1. Jan. - June 2025';
      case 'May':
        return '1. Jan. - May 2025';
      case 'April':
        return '1. Jan. - April 2025';
      case 'March':
        return '1. Jan. - March 2025';
      case 'February':
        return '1. Jan. - February 2025';
      case 'January':
        return '1. Jan. - January 2025';
      default:
        return '1. Jan. - $date 2025';
    }
  }

  String _getDetailSubtitleForYear(String date) {
    if (date == '31.August 2025') {
      return '1. Jan. - 31. August 2025';
    }
    // Extract year from date (e.g., "2024" -> "2024")
    final year = date.replaceAll(RegExp(r'[^0-9]'), '');
    if (year.isNotEmpty) {
      return '1. Jan. - 31. December $year';
    }
    return date;
  }

  String _getDetailTitleForYear(String date) {
    if (date == '31.August 2025') {
      return '2025';
    }
    // Extract year from date (e.g., "2024" -> "2024")
    final year = date.replaceAll(RegExp(r'[^0-9]'), '');
    return year.isNotEmpty ? year : date;
  }

  List<Map<String, dynamic>> _getMonthlyPerformanceData() {
    return [
      {
        'date': '31.August',
        'subtitle': '',
        'amount': 'CHF 344\'193.00',
        'percentage': '+14.00%',
        'change': 'CHF 141.22',
        'isPositive': true,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'July',
        'subtitle': '',
        'amount': 'CHF 8\'123.56',
        'percentage': '+56.00%',
        'change': 'CHF 1\'2390.00',
        'isPositive': true,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'June',
        'subtitle': '',
        'amount': 'CHF 10\'193.00',
        'percentage': '-12.00%',
        'change': 'CHF 1\'141.22',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'May',
        'subtitle': '',
        'amount': 'CHF 10\'193.00',
        'percentage': '-33.00%',
        'change': 'CHF 3\'233.22',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'April',
        'subtitle': '',
        'amount': 'CHF 10\'193.00',
        'percentage': '-12.00%',
        'change': 'CHF 2\'141.22',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'March',
        'subtitle': '',
        'amount': 'CHF 102\'193.00',
        'percentage': '+456.00%',
        'change': 'CHF 10\'431.22',
        'isPositive': true,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'February',
        'subtitle': '',
        'amount': 'CHF 10\'233.00',
        'percentage': '+0.50%',
        'change': 'CHF 231.22',
        'isPositive': true,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': 'January',
        'subtitle': '',
        'amount': 'CHF 10\'193.00',
        'percentage': '-56.00%',
        'change': 'CHF 533.22',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
    ];
  }

  List<Map<String, dynamic>> _getYearlyPerformanceData() {
    return [
      {
        'date': '31.August 2025',
        'subtitle': 'YTD',
        'amount': 'CHF 344\'193.00',
        'percentage': '+14.00%',
        'change': 'CHF 141.22',
        'isPositive': true,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': '2024',
        'subtitle': '',
        'amount': 'CHF 80\'123.56',
        'percentage': '+56.00%',
        'change': 'CHF 1\'2390.00',
        'isPositive': true,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': '2023',
        'subtitle': '',
        'amount': 'CHF 100\'148.00',
        'percentage': '-56.00%',
        'change': 'CHF 1\'213.54',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': '2022',
        'subtitle': '',
        'amount': 'CHF 232\'455.00',
        'percentage': '-34.00%',
        'change': 'CHF 141.23',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
      {
        'date': '2021',
        'subtitle': '',
        'amount': 'CHF 112\'654.00',
        'percentage': '-21.00%',
        'change': 'CHF 78.25',
        'isPositive': false,
        'cashflow': 'Cashflow CHF 0.00',
      },
    ];
  }

  Widget _buildAllocationTab(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        // Total Assets Graph
        _buildAllocationGraph(context, isDark),
        const SizedBox(height: 32),
        // Investmentsgroups List
        _buildInvestmentsGroupsList(context, isDark),
      ],
    );
  }

  Widget _buildAllocationGraph(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const positiveColor = Color(0xFF34C759);
    const double graphSize = 240; // 200 * 1.2 = 240 (20% größer)

    return SizedBox(
      width: 375,
      height: graphSize,
      child: Stack(
        children: [
          // Ring Chart
          Positioned(
            left: (375 - graphSize) / 2, // Center
            top: 0,
            child: SizedBox(
              width: graphSize,
              height: graphSize,
              child: AnimatedBuilder(
                animation: _allocationAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(graphSize, graphSize),
                    painter: _AllocationRingChartPainter(
                      animationValue: _allocationAnimation.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // Center Text - Amount
          Positioned(
            left: 0,
            top: graphSize * 0.385, // Adjusted for larger graph
            child: SizedBox(
              width: 375,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.appCurrency} ',
                      style: GoogleFonts.openSans(
                        color: AppColorSchemes.primaryDarkYellow,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    TextSpan(
                      text: context.withAppCurrency("CHF 199'882.97").replaceFirst('${context.appCurrency} ', ''),
                      style: GoogleFonts.openSans(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Performance below amount
          Positioned(
            left: 0,
            top: graphSize * 0.55, // Adjusted for larger graph
            child: SizedBox(
              width: 375,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_drop_up,
                    color: positiveColor,
                    size: 24,
                  ),
                  Text(
                    context.withAppCurrency('+4.66% | CHF +13\'163.80'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      color: positiveColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentsGroupsList(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          InkWell(
            onTap: () => _showSortingBottomSheet(context, isDark),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _selectedSorting,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                  color: textColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Content based on selected sorting
          if (_selectedSorting == 'Investmentsgroups') ...[
            // Bonds (01) CLX
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Bonds (01) CLX',
              subtitle: '',
              amount: 'CHF 44\'193.00',
              percentage: '+14.00%',
              change: 'CHF 141.22',
              isPositive: true,
              cashflow: '',
              iconColor: const Color(0xFF5BC5F2),
            ),

            const SizedBox(height: 32),

            // Shares (02) CLX
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Shares (02) CLX',
              subtitle: '',
              amount: 'CHF 344\'193.00',
              percentage: '+14.00%',
              change: 'CHF 141.22',
              isPositive: true,
              cashflow: '',
              iconColor: const Color(0xFF417691),
            ),

            const SizedBox(height: 32),

            // Liquadition (03) CLX
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Liquadition (03) CLX',
              subtitle: '',
              amount: 'CHF 344\'193.00',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: AppColorSchemes.primaryDarkYellow,
            ),
          ] else if (_selectedSorting == 'Currency') ...[
            // CHF
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'CHF',
              subtitle: '',
              amount: 'CHF 19\'774\'203.57',
              percentage: '+0.01%',
              change: 'CHF +2\'800.00',
              isPositive: true,
              cashflow: '',
              iconColor: const Color(0xFF5BC5F2),
            ),

            const SizedBox(height: 32),

            // EUR
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'EUR',
              subtitle: '',
              amount: 'CHF 43\'530.18',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: const Color(0xFF417691),
            ),

            const SizedBox(height: 32),

            // USD
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'USD',
              subtitle: '',
              amount: 'CHF 1\'758.32',
              percentage: '-2.00%',
              change: 'CHF –35.88',
              isPositive: false,
              cashflow: '',
              iconColor: AppColorSchemes.primaryDarkYellow,
            ),

            const SizedBox(height: 32),

            // GBP
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'GBP',
              subtitle: '',
              amount: 'CHF 22\'001.00',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: const Color(0xFF5BC5F2),
            ),

            const SizedBox(height: 32),

            // GOG
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'GOG',
              subtitle: '',
              amount: 'CHF 40\'640.00',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: const Color(0xFF417691),
            ),

            const SizedBox(height: 32),

            // SIG
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'SIG',
              subtitle: '',
              amount: 'CHF 530.00',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: AppColorSchemes.primaryDarkYellow,
            ),
          ] else if (_selectedSorting == 'Industry') ...[
            // Various services CLX
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Various \nservices CLX',
              subtitle: '',
              amount: 'CHF 1\'758.32',
              percentage: '-4.00%',
              change: 'CHF 35.88',
              isPositive: false,
              cashflow: '',
              iconColor: const Color(0xFF5BC5F2),
            ),

            const SizedBox(height: 32),

            // Liqu./ Market
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Liqu./ Market',
              subtitle: '',
              amount: 'CHF 19\'858\'104.75',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: const Color(0xFF417691),
            ),

            const SizedBox(height: 32),

            // Foodstuffs CLX
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Foodstuffs CLX',
              subtitle: '',
              amount: 'CHF 22\'800.00',
              percentage: '+14.00%',
              change: 'CHF 2\'800.00',
              isPositive: true,
              cashflow: '',
              iconColor: AppColorSchemes.primaryDarkYellow,
            ),
          ] else if (_selectedSorting == 'Region') ...[
            // Northamerica
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Northamerica',
              subtitle: '',
              amount: 'CHF 5\'758.32',
              percentage: '-4.00%',
              change: 'CHF 535.88',
              isPositive: false,
              cashflow: '',
              iconColor: const Color(0xFF5BC5F2),
            ),

            const SizedBox(height: 32),

            // Switzerland
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Switzerland',
              subtitle: '',
              amount: 'CHF 19\'858\'104.75',
              percentage: null,
              change: null,
              isPositive: null,
              cashflow: '',
              iconColor: const Color(0xFF417691),
            ),

            const SizedBox(height: 32),

            // Westeurope
            _buildInvestmentGroupItem(
              context: context,
              isDark: isDark,
              title: 'Westeurope',
              subtitle: '',
              amount: 'CHF 12\'345.00',
              percentage: '+220.00%',
              change: 'CHF 8\'800.00',
              isPositive: true,
              cashflow: '',
              iconColor: AppColorSchemes.primaryDarkYellow,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showSortingBottomSheet(BuildContext context, bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SortingSelectionSheet(
          selectedSorting: _selectedSorting,
          onSortingSelected: (sorting) {
            setState(() {
              _selectedSorting = sorting;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildInvestmentGroupItem({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String subtitle,
    required String amount,
    String? percentage,
    String? change,
    bool? isPositive,
    required String cashflow,
    required Color iconColor,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const positiveColor = Color(0xFF34C759);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Icon(
          Icons.data_usage,
          size: 32,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.5,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        // Amount and Performance
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              context.withAppCurrency(amount),
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.5,
              ),
            ),
            if (percentage != null && change != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive == true
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: isPositive == true ? positiveColor : const Color(0xFFC00024),
                    size: 24,
                  ),
                  Text(
                    '$percentage | ${context.withAppCurrency(change)}',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isPositive == true ? positiveColor : const Color(0xFFC00024),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
            if (cashflow.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                context.withAppCurrency(cashflow),
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle({
    required BuildContext context,
    required String title,
    required String amount,
    String? percentage,
    bool? isPositive,
    required Color color,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const positiveColor = Color(0xFF34C759);
    const negativeColor = Color(0xFFFF383C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Text(
                context.withAppCurrency(amount),
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        if (percentage != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                isPositive == true
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: isPositive == true ? positiveColor : negativeColor,
                size: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Text(
                  percentage,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isPositive == true ? positiveColor : negativeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPosition({
    required BuildContext context,
    required String title,
    required String quantity,
    required String amount,
    String? percentage,
    bool? isPositive,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const positiveColor = Color(0xFF34C759);
    const negativeColor = Color(0xFFFF383C);

    return InkWell(
      onTap: () {
        // Navigate to position detail for all positions
        context.push('/position-detail', extra: {
          'title': title,
          'amount': amount,
          'quantity': quantity,
          'percentage': percentage,
          'isPositive': isPositive,
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 24 / 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quantity,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      context.withAppCurrency(amount),
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    if (percentage != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive == true
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: isPositive == true
                                ? positiveColor
                                : negativeColor,
                            size: 24,
                          ),
                          Text(
                            percentage,
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isPositive == true
                                  ? positiveColor
                                  : negativeColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllocationRingChartPainter extends CustomPainter {
  final double animationValue;
  const _AllocationRingChartPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 13) / 2;
    const strokeWidth = 13.0;
    const gap = 2.0; // Gap between segments in degrees

    // Segments - only 3 colors: 5BC5F2, 417691, FFA814
    final segments = [
      // Light Blue - 5BC5F2 (Bonds)
      {'color': const Color(0xFF5BC5F2), 'sweep': 67.0},
      // Dark Blue - 417691 (Shares)
      {'color': const Color(0xFF417691), 'sweep': 111.0},
      // Orange - FFA814 (Liquadition)
      {'color': AppColorSchemes.primaryDarkYellow, 'sweep': 178.0},
    ];

    double currentAngle = -90.0; // Start from top

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final color = segment['color'] as Color;
      final sweepAngle = segment['sweep'] as double;
      
      // Calculate animation progress for this segment
      // Each segment takes 1/3 of the total animation
      final segmentStart = i / segments.length;
      final segmentEnd = (i + 1) / segments.length;
      
      double animatedSweep = 0.0;
      if (animationValue >= segmentEnd) {
        // Segment fully drawn
        animatedSweep = sweepAngle;
      } else if (animationValue > segmentStart) {
        // Segment partially drawn
        final segmentProgress = (animationValue - segmentStart) / (segmentEnd - segmentStart);
        animatedSweep = sweepAngle * segmentProgress;
      }

      if (animatedSweep > 0) {
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle * (3.14159 / 180), // Convert to radians
          animatedSweep * (3.14159 / 180), // Convert to radians
          false,
          paint,
        );
      }

      // Move to next segment position (add gap)
      currentAngle += sweepAngle + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _AllocationRingChartPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
