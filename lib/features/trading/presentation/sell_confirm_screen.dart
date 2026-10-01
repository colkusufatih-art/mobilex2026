import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart';

/// Sell Confirm Screen
///
/// Shows a confirmation screen before executing the sell order
class SellConfirmScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount; // Calculated amount from Pcs * Price
  final String pcs; // Pcs value (e.g., "100" or "1")
  final String stockExchange;
  final String orderType;
  final DateTime validUntil;
  final String settlementAccount;
  final String? limitChf; // If order type is Limited

  const SellConfirmScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.pcs,
    required this.stockExchange,
    required this.orderType,
    required this.validUntil,
    required this.settlementAccount,
    this.limitChf,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    final content = _buildContent(context, isDark);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(isDark: isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    // Transaction Header
                    TransactionHeader(
                      title: title,
                      subtitle: subtitle,
                      amount: amount,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),
                    ...content,
                    const SizedBox(height: 24),
                    // Accept Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/trading/sell-confirmed', extra: {
                            'title': title,
                            'amount': amount,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorSchemes.greysDarkGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Accept & execute',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),
                  ],
                ),
              ),
              const AppBottomNavigation(activeRoute: '/more'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool isDark) {
    final widgets = <Widget>[];

    // Amount
    widgets.add(_buildValueListItem(
      label: 'Amount',
      value: '$pcs Pcs.',
      subtitle: 'ca. $amount',
      isDark: isDark,
    ));

    // Stock exchange
    widgets.add(_buildValueListItem(
      label: 'Stock exchange',
      value: stockExchange.replaceAll(' / ', ' '),
      subtitle: _extractCurrency(stockExchange),
      isDark: isDark,
    ));

    widgets.add(_buildDivider(isDark));

    // Execution type (Order type)
    widgets.add(_buildValueListItem(
      label: 'Execution type',
      value: orderType,
      isDark: isDark,
    ));

    // Valid until
    widgets.add(_buildValueListItem(
      label: 'Valid until',
      value: DateFormat('dd.MM.yyyy').format(validUntil),
      isDark: isDark,
    ));

    widgets.add(_buildDivider(isDark));

    // Portfolio
    widgets.add(_buildValueListItem(
      label: 'Portfolio',
      value: '1502 CHF',
      subtitle: '771534601502',
      isDark: isDark,
    ));

    // Settlement account
    widgets.add(_buildValueListItem(
      label: 'Settlement account',
      value: 'Kontokorrent',
      subtitle: 'CH02 0076 1001 5346 0150 2',
      isDark: isDark,
    ));

    widgets.add(_buildDivider(isDark));

    // Disclaimer text
    widgets.add(_buildDisclaimer(isDark));

    return widgets;
  }


  String _extractCurrency(String stockExchange) {
    // Extract currency from stock exchange string (e.g., "CHF", "EUR")
    if (stockExchange.contains('CHF')) return 'CHF';
    if (stockExchange.contains('EUR')) return 'EUR';
    if (stockExchange.contains('USD')) return 'USD';
    return '';
  }

  Widget _buildValueListItem({
    required String label,
    required String value,
    String? subtitle,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    const subtitleColor = AppColorSchemes.greysMidGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor,
              height: 1.5,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
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
    );
  }

  Widget _buildDisclaimer(bool isDark) {
    const subtitleColor = AppColorSchemes.greysMidGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'Please note that for stock market transactions carried out via a savings account, withdrawals of up to CHF 100,000 per calendar year are possible without restriction. For amounts above CHF 100,000, a notice period of 60 calendar days applies. If you do not comply with the notice periods, we will charge a non-cancellation fee of 2% on the excess amount.\n\nCrealogix Kantonalbank merely forwards stock exchange orders for execution. It does not check or verify the plausibility of the orders, nor does it carry out any appropriateness or suitability checks. No advice is given and no recommendations are made based on your personal circumstances or the investment objectives agreed with you.\n\nSecurities transactions involve various risks. For example, warrants have a more complex risk profile than stocks or bonds. It is therefore important that you are fully aware of the characteristics and risks of the intended securities transaction before each transaction and that you have an idea of the financial viability of the risk of loss. For details, please refer to our brochure "Risks in Trading Financial Instruments." By placing stock exchange orders, you declare that you are familiar with stock exchange trading and aware of the associated risks.\n\nYou accept that, due to system constraints, purchased securities may not be able to be sold again on the same day.',
        style: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: subtitleColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: AppColorSchemes.getDividerColor(isDark),
        height: 1,
        thickness: 1,
      ),
    );
  }

}

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final backgroundColor =
        isDark ? AppColorSchemes.darkBackground : AppColorSchemes.lightBackground;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.pop(),
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
              Expanded(
                child: Text(
                  'Confirm order',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.go('/trading'),
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
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
                ),
                Expanded(
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
