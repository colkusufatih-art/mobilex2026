import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../payments/presentation/payments_screen.dart' show ExternalLinkCard;

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  int _selectedTabIndex = 0; // 0 = Pending orders, 1 = Archive

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      appBar: _buildAppBar(isDark),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      child: Text(
                        'Trading',
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: AppColorSchemes.getTextColor(isDark),
                          height: 1.25,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Market trends section
                    _buildMarketTrendsSection(isDark),

                    const SizedBox(height: AppSpacing.md),

                    // External Link Card
                    ExternalLinkCard(
                      isDark: isDark,
                      title: 'More markets',
                      showDot: false,
                      onTap: () async {
                        final uri = Uri.parse(
                            'https://www.six-group.com/de/market-data/shares/share-explorer.html');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),

                    const SizedBox(height: 32),

                    // Buy/Sell Buttons
                    _buildBuySellButtons(isDark),

                    const SizedBox(height: 32),

                    // Tabbar
                    _buildTabs(isDark),

                    // Tab content
                    _selectedTabIndex == 0
                        ? _buildPendingOrdersTab(isDark)
                        : _buildArchiveTab(isDark),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const AppBottomNavigation(activeRoute: '/more'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    final iconColor = AppColorSchemes.getTextColor(isDark);

    return AppBar(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          M3Icons.arrowBack,
          color: iconColor,
          semanticLabel: 'Zurück',
        ),
        tooltip: 'Zurück', // WCAG 2.2
        onPressed: () => context.go('/more'),
      ),
    );
  }

  Widget _buildMarketTrendsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market trends',
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColorSchemes.getTextColor(isDark),
              height: 1.94,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 143,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMarketTrendCard(
                  isDark: isDark,
                  title: 'SMI',
                  percentage: '+1.22%',
                  isPositive: true,
                  imagePath: 'assets/img/SIX-Swiss-Exchange.png',
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildMarketTrendCard(
                  isDark: isDark,
                  title: 'NDX',
                  percentage: '–0.56%',
                  isPositive: false,
                  imagePath: 'assets/img/Nasdaq-Logo.wine.png',
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildMarketTrendCard(
                  isDark: isDark,
                  title: 'DAX',
                  percentage: '–0.16%',
                  isPositive: false,
                  imagePath: 'assets/img/DAX-logo.svg.png',
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildMarketTrendCard(
                  isDark: isDark,
                  title: 'DJIA',
                  percentage: '–0.66%',
                  isPositive: true,
                  imagePath: 'assets/img/dow-jones2418.jpg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrendCard({
    required bool isDark,
    required String title,
    required String percentage,
    required bool isPositive,
    required String imagePath,
  }) {
    final percentageColor =
        isPositive ? const Color(0xFF34C759) : const Color(0xFFC00024);

    // White background for SIX (SMI) and Nasdaq (NDX)
    final bool needsWhiteBackground = title == 'SMI' || title == 'NDX';
    final backgroundColor =
        needsWhiteBackground ? Colors.white : Colors.transparent;

    // WCAG 2.2: Semantics für Market Trend Karte
    final trendDirection = isPositive ? 'steigend' : 'fallend';
    return Semantics(
      label: '$title Index, $percentage, $trendDirection',
      child: SizedBox(
        width: 162,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 162,
              height: 100,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFDADADA),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // WCAG 2.2: semanticLabel für Image
                child: Image.asset(
                  imagePath,
                  width: 162,
                  height: 100,
                  fit: BoxFit.cover,
                  semanticLabel: '$title Logo',
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 162,
                      height: 100,
                      color: AppColorSchemes.getCardBackgroundColor(isDark),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColorSchemes.getTextColor(isDark),
                    height: 2.19,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: percentageColor,
                      size: 24,
                      semanticLabel: trendDirection,
                    ),
                  Text(
                    percentage,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: percentageColor,
                      height: 1.5,
                    ),
                  ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // horizontally scrollable tabs
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Pending orders Tab
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
                                  'Pending orders',
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

                      // Archive Tab
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
                                  'Archive',
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
                    ],
                  ),
                ),
              ),
              // Search icon pinned right
              Transform.translate(
                offset: const Offset(0, -8),
                child: InkWell(
                  onTap: () {
                    context.push('/trading/search');
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
        // Divider
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

  Widget _buildBuySellButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => context.push('/trading/buy'),
              child: _buildActionButton(
                icon: Icons.arrow_downward,
                text: 'Buy',
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/trading/sell'),
              child: _buildActionButton(
                icon: Icons.arrow_upward,
                text: 'Sell',
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrdersTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trading positions list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildTradingPosition(
                isDark: isDark,
                title: 'Akt. 3M USD 0.01 (998421819)',
                subtitle: 'Buy | USD 200.01 | 30.09.2025',
                amount: '99.00%',
                percentage: 'recorded',
                isPositive: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildTradingPosition(
                isDark: isDark,
                title: 'Akt. The Swatch Group (12255515)',
                subtitle: 'Buy | 11 Pcs. | 02.09.2025',
                amount: 'EUR 360.29',
                percentage: 'recorded',
                isPositive: false,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildTradingPosition(
                isDark: isDark,
                title: 'Akt. The Swatch Group (12255515)',
                subtitle: 'Buy | 20 Pcs. | 01.09.2025',
                amount: 'EUR 360.29',
                percentage: 'placed',
                isPositive: false,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildTradingPosition(
                isDark: isDark,
                title: 'Akt. The Swatch Group (12255515)',
                subtitle: 'Buy | 20 Pcs. | 01.09.2025',
                amount: 'EUR 360.29',
                percentage: 'placed',
                isPositive: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArchiveTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildTradingPosition(
            isDark: isDark,
            title: '4.25 % Givaudan 2009 – 30.11.2026 (998421821)',
            subtitle: 'Buy | CHF 300.00 | 27.09.2025',
            amount: '95.00%',
            percentage: 'executed',
            isPositive: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTradingPosition(
            isDark: isDark,
            title: 'Akt. 3M USD 0.01 (998421819)',
            subtitle: 'Sell | CHF 300.00 | 30.09.2025',
            amount: '99.00%',
            percentage: 'executed',
            isPositive: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTradingPosition(
            isDark: isDark,
            title: 'Nam. Akt. Nestlè AG CHF 0.10 (998421828)',
            subtitle: 'Buy | 1000 Pcs. | 21.09.2025',
            amount: 'EUR 50.00',
            percentage: 'accepted',
            isPositive: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTradingPosition(
            isDark: isDark,
            title: 'Nam. Akt. Swisscom AG\nCHF 1 nom. (874251)',
            subtitle: 'Buy | 377 Pcs. | 01.09.2025',
            amount: 'EUR 334.75',
            percentage: 'executed',
            isPositive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColorSchemes.getCardBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColorSchemes.getTextColor(isDark),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingPosition({
    required bool isDark,
    required String title,
    required String subtitle,
    required String amount,
    required String percentage,
    required bool isPositive,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const percentageColor = subtitleColor;

    // Extract order type from subtitle (Buy or Sell)
    final orderType = subtitle.split('|').first.trim();

    return InkWell(
      onTap: () {
        context.push('/trading/pending-order-detail', extra: {
          'title': title,
          'amount': amount,
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
                    title,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
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
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  percentage,
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
}
