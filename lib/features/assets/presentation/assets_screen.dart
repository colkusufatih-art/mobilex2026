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
import '../../../ui/components/bottom_sheets/account_selection_sheet.dart';
import '../../../ui/components/bottom_sheets/notifications_bottom_sheet.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

/// Assets Screen
/// 
/// Figma frame: Assets (27:2576)
/// Assets overview with sections for Accounts, Investments, Pension, and Mortgages
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  String selectedAccount = 'Reto Haldner';
  bool _isNumbersVisible = true;
  late AccountNotifier _accountNotifier;

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

  String _getAccountAlias(String accountName) {
    return _accountNotifier.getAlias(accountName);
  }

  // Get accounts total based on selected account
  String get _accountsTotal {
    double accounts;
    switch (selectedAccount) {
      case 'Reto Haldner':
        accounts = 149741.60;
        break;
      case 'Mareike Haldner':
        accounts = 1200000.00;
        break;
      case 'Vanessa Haldner':
        accounts = 15000.00;
        break;
      case 'Sportverein Wetzikon':
        accounts = 15000000.00;
        break;
      default:
        accounts = 149741.60;
    }
    return _formatAmount(accounts);
  }

  // Get investments total based on selected account
  String get _investmentsTotal {
    double investments;
    switch (selectedAccount) {
      case 'Reto Haldner':
        investments = 60643.30;
        break;
      case 'Mareike Haldner':
        investments = 450000.00;
        break;
      case 'Vanessa Haldner':
        investments = 5000.00;
        break;
      case 'Sportverein Wetzikon':
        investments = 8000000.00;
        break;
      default:
        investments = 60643.30;
    }
    return _formatAmount(investments);
  }

  // Get pension amount as double (sum of Pillar 3a and Pillar 3a - AXA Life)
  double get _pensionAmount {
    // Pillar 3a: CHF 44'323.00
    // Pillar 3a - AXA Life: CHF 100'000.00
    // Total: 44'323.00 + 100'000.00 = 144'323.00
    const double pillar3a = 44323.00;
    const double pillar3aAxa = 100000.00;
    return pillar3a + pillar3aAxa;
  }

  // Get pension total by calculating sum of Pillar 3a and Pillar 3a - AXA Life
  String get _pensionTotal {
    return _formatAmount(_pensionAmount);
  }

  // Helper method to format amounts with apostrophes
  String _formatAmount(double amount) {
    String formatted = amount.toStringAsFixed(2);
    List<String> parts = formatted.split('.');
    String beforeDecimal = parts[0];
    String afterDecimal = parts[1];
    
    // Add apostrophes for thousands separators (every 3 digits from right)
    if (beforeDecimal.length > 3) {
      String formattedNumber = '';
      int digits = beforeDecimal.length;
      for (int i = 0; i < digits; i++) {
        if (i > 0 && (digits - i) % 3 == 0) {
          formattedNumber += '\'';
        }
        formattedNumber += beforeDecimal[i];
      }
      beforeDecimal = formattedNumber;
    }
    
    return 'CHF $beforeDecimal.$afterDecimal';
  }

  // Calculate total assets from all sections based on selected account
  String get _totalAssets {
    double accounts;
    double investments;
    
    // Different totals for each account
    switch (selectedAccount) {
      case 'Reto Haldner':
        accounts = 149741.60;
        investments = 60643.30;
        break;
      case 'Mareike Haldner':
        accounts = 1200000.00;
        investments = 450000.00;
        break;
      case 'Vanessa Haldner':
        accounts = 15000.00;
        investments = 5000.00;
        break;
      case 'Sportverein Wetzikon':
        accounts = 15000000.00;
        investments = 8000000.00;
        break;
      default:
        accounts = 149741.60;
        investments = 60643.30;
    }
    
    // Pension is calculated from Pillar 3a and Pillar 3a - AXA Life
    final double pension = _pensionAmount;
    
    double total = accounts + investments + pension;
    
    return _formatAmount(total);
  }

  void _toggleNumbersVisibility() {
    setState(() {
      _isNumbersVisible = !_isNumbersVisible;
    });
  }

  void _showNotificationsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const NotificationsBottomSheet(),
    );
  }

  void _showAccountSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4), // Darken layer
        ),
        child: AccountSelectionSheet(
          selectedAccount: selectedAccount,
          onAccountSelected: (account) {
            setState(() {
              selectedAccount = account;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              _buildHeader(isDark),
              
              const SizedBox(height: AppSpacing.md),
              
              // Total Assets
              _buildTotalAssets(context, isDark),
              
              const SizedBox(height: AppSpacing.md),
              
              // Graph
              _buildGraph(isDark),
              
              const SizedBox(
                  height:
                      60), // 60px Abstand zwischen Total Amount und Accounts Section
              
              // Assets List
              Expanded(
                child: _buildAssetsList(context, isDark),
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
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // User Name with Tap
          InkWell(
            onTap: _showAccountSelectionSheet,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs, horizontal: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedAccount,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    M3Icons.keyboardArrowDown,
                    color:
                        isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Action Buttons
          Row(
            children: [
              _buildActionButton(
                _isNumbersVisible ? M3Icons.visibilityOff : M3Icons.visibility,
                isDark,
                onTap: _toggleNumbersVisibility,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionButton(
                M3Icons.notificationsNone,
                isDark,
                onTap: _showNotificationsBottomSheet,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, bool isDark, {VoidCallback? onTap}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColorSchemes.getCardBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Icon(
          icon,
          color: AppColorSchemes.getTextColor(isDark),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTotalAssets(BuildContext context, bool isDark) {
    final displayAmount = context.withAppCurrency(_totalAssets);
    final currency = context.appCurrency;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          _isNumbersVisible
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$currency ',
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w600, // ✅ Semibold
                          color:
                              AppColorSchemes.primaryDarkYellow, // Active color #FFA814
                          height: 1.4,
                          letterSpacing: 0,
                        ),
                      ),
                      TextSpan(
                        text: displayAmount.replaceFirst('$currency ', ''),
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w600, // ✅ Semibold
                          color: isDark
                              ? Colors.white
                              : AppColorSchemes.greysDarkGrey,
                          height: 1.4,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  '••••••••',
                  style: GoogleFonts.openSans(
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                    color: AppColorSchemes.greysMidGrey,
                    height: 1.4,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
  }

  Widget _buildGraph(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 8,
            decoration: BoxDecoration(
              color: AppColorSchemes.primaryDarkYellow,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 2),
          Container(
            width: 80,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF417691),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 2),
          Container(
            width: 40,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF5bc5f2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          // Accounts Section
          _buildSection(
            context: context,
            title: 'Accounts',
            total: _accountsTotal,
            color: AppColorSchemes.primaryDarkYellow,
            isDark: isDark,
            children: [
              _buildAssetCard(
                context: context,
                title: _getAccountAlias('Private Account'),
                originalName: 'Private Account',
                amount: 'CHF 4\'323.30',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAssetCard(
                context: context,
                title: _getAccountAlias('Family Account'),
                originalName: 'Family Account',
                amount: 'CHF 32\'454.30',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAssetCard(
                context: context,
                title: _getAccountAlias('Savings Account'),
                originalName: 'Savings Account',
                amount: 'CHF 112\'500.30',
                isDark: isDark,
              ),
            ],
          ),
          
          const SizedBox(height: 32), // 32px Abstand zwischen Sections
          
          // Investments Section
          _buildSection(
            context: context,
            title: 'Investments',
            total: _investmentsTotal,
            color: const Color(0xFF417691),
            isDark: isDark,
            children: [
              _buildAssetCard(
                context: context,
                title: context.withAppCurrency('1501 CHF'),
                amount: 'CHF 10\'193.00',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAssetCard(
                context: context,
                title: context.withAppCurrency('1502 CHF'),
                amount: 'CHF 50\'454.30',
                isDark: isDark,
              ),
            ],
          ),
          
          const SizedBox(height: 32), // 32px Abstand zwischen Sections
          
          // Pension Section
          _buildSection(
            context: context,
            title: 'Pension',
            total: _pensionTotal,
            color: const Color(0xFF5bc5f2),
            isDark: isDark,
            children: [
              _buildAssetCard(
                context: context,
                title: 'Pillar 3a',
                amount: 'CHF 44\'323.00',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAssetCard(
                context: context,
                title: 'Pillar 3a - AXA Life',
                amount: 'CHF 100\'000.00',
                isDark: isDark,
              ),
            ],
          ),
          
          const SizedBox(height: 32), // 32px Abstand zwischen Sections
          
          // Mortgages Section
          _buildSection(
            context: context,
            title: 'Mortgages',
            total: 'CHF 2\'000\'000.00',
            color: AppColorSchemes.greysMidGrey,
            isDark: isDark,
            children: [
              _buildAssetCard(
                context: context,
                title: 'Seestrasse 1, Zürich',
                amount: 'CHF 800\'000.00',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAssetCard(
                context: context,
                title: 'Römerweg 32, Baden',
                amount: 'CHF 1\'200\'000.00',
                isDark: isDark,
              ),
            ],
          ),
          
          const SizedBox(height: 32), // 32px Abstand vor Bottom Bar
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String total,
    required Color color,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
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
            const SizedBox(width: 16), // 16px Abstand wie im Bild
            Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColorSchemes.getTextColor(isDark),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 16), // 16px padding left
              child: _isNumbersVisible
                  ? Text(
                      context.withAppCurrency(total),
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.getTextColor(isDark),
                      ),
                    )
                  : Text(
                      '••••••••',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColorSchemes.greysMidGrey,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Section Cards
        ...children,
      ],
    );
  }

  Widget _buildAssetCard({
    required BuildContext context,
    required String title,
    String? originalName,
    required String amount,
    required bool isDark,
  }) {
    final accountName = originalName ?? title;
    return InkWell(
      onTap: () {
        // Check if it's a portfolio (1501 CHF/EUR or 1502 CHF/EUR)
        if (title.startsWith('1501') || title.startsWith('1502')) {
          // Navigate to Portfolio Detail
          context.push('/portfolio-detail', extra: {
            'title': title,
            'amount': amount,
          });
        } else if (title == 'Pillar 3a' || title == 'Pillar 3a - AXA Life') {
          // Navigate to Pension Detail
          context.push('/pension-detail', extra: {
            'title': title,
            'amount': amount,
          });
        } else if (title == 'Seestrasse 1, Zürich' || title == 'Römerweg 32, Baden') {
          // Navigate to Mortgage Detail
          context.push('/mortgage-detail', extra: {
            'title': title,
            'amount': amount,
          });
        } else {
          // Navigate to Account Transactions with dynamic data
          context.go('/account-transactions', extra: {
            'accountName': accountName,
            'accountBalance': amount,
            'accountType': _getAccountType(accountName),
          });
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 78, // 78px Höhe wie gewünscht
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColorSchemes.getCardBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                // Use alias for portfolio and pension cards, otherwise use title
                (title.startsWith('1501') || 
                 title.startsWith('1502') || 
                 title == 'Pillar 3a' || 
                 title == 'Pillar 3a - AXA Life')
                    ? _getAccountAlias(title.startsWith('1501')
                        ? '1501 CHF'
                        : title.startsWith('1502')
                            ? '1502 CHF'
                            : title)
                    : title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
            _isNumbersVisible
                ? Text(
                    context.withAppCurrency(amount),
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
          ],
        ),
      ),
    );
  }

  String _getAccountType(String accountName) {
    // Determine account type based on name
    if (accountName.contains('Private Account')) {
      return 'Private';
    } else if (accountName.contains('Savings Account')) {
      return 'Savings';
    } else if (accountName.contains('Portfolio')) {
      return 'Investment';
    } else if (accountName.contains('Pillar 3a')) {
      return 'Pension';
    } else if (accountName.contains('Seestrasse') ||
        accountName.contains('Römerweg')) {
      return 'Mortgage';
    }
    return 'Account';
  }
}
