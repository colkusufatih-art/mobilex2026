import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../ui/components/bottom_sheets/depot_selection_sheet.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  String _selectedDepot = '1501 CHF\n771534621599';

  /// Whether the selected depot uses EUR (e.g. 1518 EUR) - show all amounts in EUR.
  bool get _useEurFromDepot => _selectedDepot.contains('1518 EUR');

  String _toDisplayAmount(String amount) =>
      _useEurFromDepot ? amount.replaceAll('CHF', 'EUR') : amount;

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
              _ProgressHeader(isDark: isDark, title: 'Sell'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Depot Dropdown
                      _buildDepotDropdown(isDark),
                      const SizedBox(height: 16),
                      // Positions List
                      _buildPositionsList(isDark),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              const AppBottomNavigation(activeRoute: '/more'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepotDropdown(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDepotSelectionSheet(isDark),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColorSchemes.darkCardBackground
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Depot',
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColorSchemes.greysMidGrey,
                          letterSpacing: 0.12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedDepot,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColorSchemes.getTextColor(isDark),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: AppColorSchemes.getTextColor(isDark),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDepotSelectionSheet(bool isDark) async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DepotSelectionSheet(
          selectedDepot: _selectedDepot,
          onDepotSelected: (value) {
            setState(() {
              _selectedDepot = value;
            });
          },
          hideCurrentAccount: true,
          useEurForDisplay: _selectedDepot.contains('1518 EUR'),
        ),
      ),
    );
  }

  Widget _buildPositionsList(bool isDark) {
    final positions = _getSellPositions();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: positions.map((position) {
          return _buildPositionItem(
            isDark: isDark,
            title: position['title'] as String,
            subtitle: position['subtitle'] as String,
            amount: _toDisplayAmount(position['amount'] as String),
            percentage: position['percentage'] as String?,
            isPositive: position['isPositive'] as bool?,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPositionItem({
    required bool isDark,
    required String title,
    required String subtitle,
    required String amount,
    String? percentage,
    bool? isPositive,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;
    const positiveColor = Color(0xFF34C759);
    const negativeColor = Color(0xFFFF383C);

    return InkWell(
      onTap: () {
        context.push('/trading/sell-position-detail', extra: {
          'title': title,
          'amount': amount,
          'subtitle': subtitle,
          'percentage': percentage,
          'isPositive': isPositive,
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
              if (percentage != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive == true
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: isPositive == true ? positiveColor : negativeColor,
                      size: 24,
                    ),
                    Text(
                      percentage,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isPositive == true ? positiveColor : negativeColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSellPositions() {
    return [
      {
        'title': '3 % Kanton Zürich 2004 –\n31.07.2026 (1737171)',
        'subtitle': '100 Pcs.',
        'amount': 'CHF 1\'758.32',
        'percentage': '+14.00%',
        'isPositive': true,
      },
      {
        'title': '10 % GMNA 1987 – 30.09.2027 Pool No...',
        'subtitle': '2000 Pcs.',
        'amount': 'CHF 54\'867.22',
        'percentage': '–9.00%',
        'isPositive': false,
      },
      {
        'title': 'Nam. Akt. Nestlè AG CHF 0.10 (3886335)',
        'subtitle': '100 Pcs.',
        'amount': 'CHF 54\'867.22',
        'percentage': '–21.00%',
        'isPositive': false,
      },
      {
        'title': 'Tesla Inc.',
        'subtitle': '1000 Pcs.',
        'amount': 'CHF 55\'400.00',
        'percentage': '–14.00%',
        'isPositive': false,
      },
      {
        'title': 'Put Nestlè Eurex 02.2026 CHF 78.00 ',
        'subtitle': '5 Pcs.',
        'amount': 'CHF 850.00',
        'percentage': null,
        'isPositive': null,
      },
    ];
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

