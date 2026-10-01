import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilex2025/core/currency/currency_scope.dart';
import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/core/theme/radius.dart';
import 'package:mobilex2025/core/theme/typography.dart';
import 'package:mobilex2025/core/icons/m3_icons.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/account_selection_sheet.dart';
import 'package:mobilex2025/ui/components/bottom_sheets/notifications_bottom_sheet.dart';

/// Home Screen
///
/// Figma frame: Home (14:3101)
/// Dashboard with assets, cards slider, and insights slider
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String selectedAccount = 'Reto Haldner';
  bool _isNumbersVisible = true;
  bool _showGraphView = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleGraphView() {
    if (_showGraphView) {
      // Closing graph: reverse animation, then update state
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showGraphView = false;
          });
        }
      });
    } else {
      // Opening graph: update state, then forward animation
      setState(() {
        _showGraphView = true;
      });
      _animationController.forward();
    }
  }

  String get _accountBalance {
    switch (selectedAccount) {
      case 'Reto Haldner':
        return 'CHF 21\'454.30';
      case 'Mareike Haldner':
        return 'CHF 299\'126.30';
      case 'Vanessa Haldner':
        return 'CHF 454.30';
      case 'Sportverein Wetzikon':
        return 'CHF 2\'532\'454.30';
      default:
        return 'CHF 21\'454.30';
    }
  }

  void _toggleNumbersVisibility() {
    setState(() {
      _isNumbersVisible = !_isNumbersVisible;
    });
  }

  // Helper method to create RichText with currency in active color and numbers in text color
  Widget _buildChfAmountText(
      BuildContext context, String amount, TextStyle baseStyle, bool isDark) {
    final displayAmount = context.withAppCurrency(amount);
    final currency = context.appCurrency;
    if (!displayAmount.startsWith('$currency ')) {
      return Text(displayAmount, style: baseStyle);
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$currency ',
            style: baseStyle.copyWith(
                color: AppColorSchemes.amountAccentColor), // Active color #FFA814
          ),
          TextSpan(
            text: displayAmount.replaceFirst('$currency ', ''),
            style:
                baseStyle.copyWith(color: AppColorSchemes.getTextColor(isDark)),
          ),
        ],
      ),
    );
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
              // Header
              _buildHeader(isDark),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Total Assets Amount (hidden when graph is shown)
                      if (!_showGraphView) _buildTotalAssets(context, isDark),

                      // Graph View (animated) - appears above Total Assets button
                      if (_showGraphView) ...[
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return _buildGraphView(context, isDark);
                          },
                        ),
                        const SizedBox(height: 16),
                        // Total Assets Button (always visible)
                        _buildTotalAssetsButton(isDark),
                        const SizedBox(height: 32),
                      ],

                      if (!_showGraphView) const SizedBox(height: 60),

                      // Action Buttons
                      _buildActionButtons(isDark),

                      const SizedBox(height: 60),

                      // Cards Slider
                      _buildCardsSlider(isDark),

                      const SizedBox(height: 60),

                      // Invests Section
                      _buildInvestsSection(context, isDark),

                      const SizedBox(height: 60),

                      // Insights Slider
                      _buildInsightsSlider(isDark),

                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              const AppBottomNavigation(activeRoute: '/home'),
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
                    style: AppTypography.font(
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

  Widget _buildActionButton(IconData icon, bool isDark, {VoidCallback? onTap, String? tooltip}) {
    // WCAG 2.2: Icon-Tooltip basierend auf Icon
    final String label = tooltip ?? _getIconTooltip(icon);
    
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Container(
          width: 48, // WCAG 2.5: Minimum Touch Target 48x48
          height: 48,
          decoration: BoxDecoration(
            color: AppColorSchemes.getCardBackgroundColor(isDark),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Center(
              child: Icon(
                icon,
                color: AppColorSchemes.getTextColor(isDark),
                size: 24,
                semanticLabel: label,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  String _getIconTooltip(IconData icon) {
    if (icon == M3Icons.qrCodeScanner) return 'QR-Code scannen';
    if (icon == M3Icons.search) return 'Suchen';
    if (icon == M3Icons.notificationsNone) return 'Benachrichtigungen';
    if (icon == M3Icons.visibility) return 'Beträge anzeigen';
    if (icon == M3Icons.visibilityOff) return 'Beträge ausblenden';
    return 'Aktion';
  }

  Widget _buildTotalAssets(BuildContext context, bool isDark) {
    final displayAmount = context.withAppCurrency(_accountBalance);
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
                        style: AppTypography.font(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color:
                              AppColorSchemes.amountAccentColor, // Active color #FFA814
                          height: 1.25,
                          letterSpacing: 0,
                        ),
                      ),
                      TextSpan(
                        text: displayAmount.replaceFirst('$currency ', ''),
                        style: AppTypography.font(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : AppColorSchemes.greysDarkGrey,
                          height: 1.25,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  '••••••••',
                  style: AppTypography.font(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColorSchemes.greysMidGrey,
                    height: 1.25,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: AppSpacing.sm),
          // Filter chip
          _buildTotalAssetsButton(isDark),
        ],
      ),
    );
  }

  Widget _buildTotalAssetsButton(bool isDark) {
    return InkWell(
      onTap: _toggleGraphView,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColorSchemes.getCardBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(M3Icons.accountBalanceWallet,
                size: 18, color: AppColorSchemes.getTextColor(isDark)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Total Assets',
              style: AppTypography.font(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColorSchemes.getTextColor(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _buildSquaredButton(
              icon: M3Icons.qrCodeScanner,
            text: 'Scan',
              isDark: isDark,
              onTap: () => GoRouter.of(context).push('/payments/qr-scan'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildSquaredButton(
            icon: Icons.add,
            text: 'Pay',
              isDark: isDark,
              onTap: () => context.push('/payments/new-payment'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildSquaredButton(
            icon: Icons.compare_arrows,
            text: 'Transfer',
              isDark: isDark,
              onTap: () => context.push('/payments/account-transfer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquaredButton({
    required IconData icon,
    required String text,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    // WCAG 2.2: Semantics für Action-Buttons
    return Semantics(
      button: true,
      label: text,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            height: 75, // WCAG 2.5: Ausreichende Touch Target Höhe
            decoration: BoxDecoration(
              color: AppColorSchemes.getCardBackgroundColor(isDark),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon, 
                  size: 24, 
                  color: AppColorSchemes.getTextColor(isDark),
                  semanticLabel: text,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  text,
                  style: AppTypography.font(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColorSchemes.getTextColor(isDark),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardsSlider(bool isDark) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _buildCard(
            title: 'Investment',
            subtitle: 'Start your invest in Säule 3A with Crealogix!',
            imagePath: 'assets/img/Slider-image_1.png',
            isDark: isDark,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildCard(
            title: 'Cards',
            subtitle: 'Order your Crealogix Credit Card',
            imagePath: 'assets/img/Slider-image_2.png',
            isDark: isDark,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildCard(
            title: 'BonusPass ZVV-CLX',
            subtitle: 'Order your Crealogix BonusPass and benefit.',
            imagePath: 'assets/img/Slider-image_3.png',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isDark,
  }) {
    // WCAG 2.2: Semantics für Marketing-Karten
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: InkWell(
        onTap: () {
          // Navigate based on card title
          if (title == 'Investment') {
            context.go('/cards-benefits');
          } else if (title == 'Cards') {
            context.go('/credit-card-benefits');
          } else if (title == 'BonusPass ZVV-CLX') {
            context.go('/bonuspass-benefits');
          }
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          width: 311,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColorSchemes.getCardBackgroundColor(isDark),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTypography.font(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColorSchemes.getTextColor(isDark),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.font(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColorSchemes.greysMidGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Image - WCAG 2.2: semanticLabel für Screenreader
              Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                semanticLabel: '$title Bild',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvestsSection(BuildContext context, bool isDark) {
    final currency = context.appCurrency;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColorSchemes.darkCardBackground.withValues(alpha: 0.5)
            : AppColorSchemes.greysMidGrey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invests',
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _isNumbersVisible
              ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$currency ',
                        style: AppTypography.font(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              AppColorSchemes.amountAccentColor, // Active color #FFA814
                        ),
                      ),
                      TextSpan(
                        text: context.withAppCurrency('CHF 42\'598.58').replaceFirst('$currency ', ''),
                        style: AppTypography.font(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColorSchemes.getTextColor(isDark),
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  '••••••••',
                  style: AppTypography.font(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColorSchemes.greysMidGrey,
                    letterSpacing: 1.5,
                  ),
                ),
          const SizedBox(height: AppSpacing.md),
          Column(
            children: [
              // Savings - Full width
              _buildInvestCard(
                context: context,
                icon: M3Icons.energySavingsLeaf,
                title: 'Savings',
                amount: 'CHF 8\'000.00',
                isDark: isDark,
                isFullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Pillar 3a and Shares - Side by side
              Row(
                children: [
                  Expanded(
                    child: _buildInvestCard(
                      context: context,
                      icon: M3Icons.accountBalance,
                      title: 'Pillar 3a',
                      amount: 'CHF 32\'364.00',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildInvestCard(
                      context: context,
                      icon: M3Icons.pieChart,
                      title: 'Shares',
                      amount: 'CHF 2\'234.58',
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvestCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String amount,
    required bool isDark,
    bool isFullWidth = false,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColorSchemes.getCardBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: isFullWidth
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 24, color: textColor),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                _isNumbersVisible
                    ? _buildChfAmountText(
                        context,
                        amount,
                        AppTypography.font(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        isDark,
                      )
                    : Text(
                        '••••',
                        style: AppTypography.font(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColorSchemes.greysMidGrey,
                          letterSpacing: 1,
                        ),
                      ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 24, color: textColor),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                _isNumbersVisible
                    ? _buildChfAmountText(
                        context,
                        amount,
                        AppTypography.font(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        isDark,
                      )
                    : Text(
                        '••••',
                        style: AppTypography.font(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColorSchemes.greysMidGrey,
                          letterSpacing: 1,
                        ),
                      ),
              ],
            ),
    );
  }

  Widget _buildInsightsSlider(bool isDark) {
    return Container(
      height: 202,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insights',
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildInsightCard(
                  title: 'Start your own Business',
                  subtitle: 'Start your invest with\nCrealogix!',
                  backgroundImage: 'assets/img/Slider-1.png',
                  route: '/article',
                  isDark: isDark,
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildInsightCard(
                  title: 'Benefit from our low-cost loans',
                  subtitle: 'Start your invest with\nCrealogix!',
                  backgroundImage: 'assets/img/Slider-2.png',
                  route: '/article-loans',
                  isDark: isDark,
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildInsightCard(
                  title: 'Start Brokarage with Crealogix',
                  subtitle: 'Start your invest with\nCrealogix!',
                  backgroundImage: 'assets/img/Slider-3.png',
                  route: '/article-brokerage',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String subtitle,
    required String backgroundImage,
    required String route,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        context.go(route, extra: {
          'title': title,
          'subtitle': subtitle,
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 343,
        height: 153,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: isDark
                ? AppColorSchemes.greysDarkGrey.withValues(alpha: 0.7)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTypography.font(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphView(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final displayAmount = context.withAppCurrency(_accountBalance);
    final currency = context.appCurrency;

    return SizedBox(
      width: 375,
      height: 357 * _animation.value, // Animate height
      child: Opacity(
        opacity: _animation.value,
        child: Stack(
          children: [
            // Ring Chart
            Positioned(
              left: 88,
              top: 16, // 16px spacing from header
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      left: 1,
                      top: 0,
                      child: CustomPaint(
                        size: const Size(198.85, 198.85),
                        painter: _RingChartPainter(
                          animationValue: _animation.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Text
            Positioned(
              left: 0,
              top: 70, // Adjusted to align with new graph position (16 + 54)
              child: Opacity(
                opacity: _animation.value,
                child: SizedBox(
                  width: 375,
                  child: _isNumbersVisible
                      ? Text.rich(
                          TextSpan(
                            children: [
                        TextSpan(
                          text: '$currency\n',
                          style: AppTypography.font(
                            color: AppColorSchemes.amountAccentColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                          ),
                        ),
                        TextSpan(
                          text: displayAmount.replaceFirst('$currency ', ''),
                          style: AppTypography.font(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                          ),
                        ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          '••••••••',
                          style: AppTypography.font(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColorSchemes.greysMidGrey,
                            height: 1.40,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),

            // Legend
            Positioned(
              left: 0,
              top: 269,
              child: Opacity(
                opacity: _animation.value,
                child: SizedBox(
                  width: 375,
                  height: 80,
                  child: Stack(
                    children: [
                      // Accounts (15%) - Top Left
                      Positioned(
                        left: 19,
                        top: 29,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.24,
                              height: 8.24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF5BC5F2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Accounts (15%)',
                              style: AppTypography.font(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Savings (25%) - Top Center
                      Positioned(
                        left: 149,
                        top: 29,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.24,
                              height: 8.24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF417691),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Savings (25%)',
                              style: AppTypography.font(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Shares (40%) - Top Right
                      Positioned(
                        left: 269,
                        top: 29,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.24,
                              height: 8.24,
                              decoration: BoxDecoration(
                                color: AppColorSchemes.amountAccentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Shares (40%)',
                              style: AppTypography.font(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Investments (5%) - Bottom Left
                      Positioned(
                        left: 18,
                        top: 61,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.24,
                              height: 8.24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF88C2B9),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Investments (5%)',
                              style: AppTypography.font(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Mortgages (15%) - Bottom Center
                      Positioned(
                        left: 149,
                        top: 61,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.24,
                              height: 8.24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF34C759),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mortgages (15%)',
                              style: AppTypography.font(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class _RingChartPainter extends CustomPainter {
  final double animationValue;
  const _RingChartPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 13) / 2;
    const strokeWidth = 13.0;
    const gap = 2.0; // Gap between segments in degrees

    // Segments in order: Accounts (15%), Savings (25%), Shares (40%), Investments (5%), Mortgages (15%)
    // Starting from top (-90 degrees)
    final segments = [
      // Accounts (15%) - Light Blue - starts at -90, goes 54 degrees
      {'color': const Color(0xFF5BC5F2), 'start': -90.0, 'sweep': 54.0},
      // Savings (25%) - Dark Blue - starts at -36, goes 90 degrees
      {'color': const Color(0xFF417691), 'start': -36.0, 'sweep': 90.0},
      // Shares (40%) - Orange - starts at 54, goes 144 degrees
      {'color': AppColorSchemes.amountAccentColor, 'start': 54.0, 'sweep': 144.0},
      // Investments (5%) - Teal - starts at 198, goes 18 degrees
      {'color': const Color(0xFF88C2B9), 'start': 198.0, 'sweep': 18.0},
      // Mortgages (15%) - Green - starts at 216, goes 54 degrees
      {'color': const Color(0xFF34C759), 'start': 216.0, 'sweep': 54.0},
    ];

    double currentAngle = -90.0; // Start from top

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final color = segment['color'] as Color;
      final sweepAngle = segment['sweep'] as double;
      
      // Calculate animation progress for this segment
      // Each segment takes 1/5 of the total animation
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
  bool shouldRepaint(covariant _RingChartPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
