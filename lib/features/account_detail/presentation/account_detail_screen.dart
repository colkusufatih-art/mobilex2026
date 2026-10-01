import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/icons/m3_icons.dart';
import '../../../../core/account/account_notifier.dart';
import '../../../../app.dart';
import '../../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../../../ui/components/bottom_sheets/change_alias_sheet.dart';

class AccountDetailScreen extends StatefulWidget {
  final String accountTitle;
  const AccountDetailScreen({super.key, this.accountTitle = 'Private Account'});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  late AccountNotifier _accountNotifier;
  late String _originalAccountName;

  @override
  void initState() {
    super.initState();
    _accountNotifier = context.accountNotifier!;
    _originalAccountName = widget.accountTitle;
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

  String get _currentAlias {
    return _accountNotifier.getAlias(_originalAccountName);
  }

  void _showChangeAliasSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4), // Darken layer
        ),
        child: ChangeAliasSheet(
          currentAlias: _currentAlias,
          onSave: (newAlias) {
            _accountNotifier.setAlias(_originalAccountName, newAlias);
          },
        ),
      ),
    );
  }

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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    _buildTitleSection(isDark),

                    const SizedBox(height: AppSpacing.md),

                    // QR Code Section
                    _buildQRCodeSection(isDark),

                    // Divider with 24px spacing
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),

                    // Account Owner
                    _buildPropertyItem(
                      label: 'Account Owner',
                      value: 'Reto Haldner',
                      subtitle: 'Weidstrasse 28\n8620 Wetzikon',
                      isDark: isDark,
                      isAddress: true,
                    ),

                    // IBAN with Copy Button
                    _buildPropertyItemWithAction(
                      label: 'IBAN',
                      value: 'CH76 0076 7000 0000 0000 0',
                      subtitle: '',
                      isDark: isDark,
                      icon: M3Icons.contentCopy,
                      onIconPressed: () {
                        // Handle copy action
                      },
                    ),

                    // Account Type
                    _buildPropertyItem(
                      label: 'Account Type',
                      value: 'Private Account',
                      subtitle: 'CHF - Swiss Francs',
                      isDark: isDark,
                    ),

                    // Bank
                    _buildPropertyItem(
                      label: 'Bank',
                      value: 'Crealogix Bank',
                      subtitle: 'Clearing Number 007',
                      isDark: isDark,
                    ),

                    // Bank Interest Rate
                    _buildPropertyItem(
                      label: 'Bank Interest Rate',
                      value: '0.25%',
                      subtitle: '',
                      isDark: isDark,
                    ),

                    // Number
                    _buildPropertyItem(
                      label: 'Number',
                      value: 'CH 76 0076 7000 0000 0000 0',
                      subtitle: '',
                      isDark: isDark,
                    ),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const AppBottomNavigation(activeRoute: '/account-detail'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          M3Icons.arrowBack,
          color: isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
        ),
        onPressed: () => context.go('/account-transactions'),
      ),
    );
  }

  Widget _buildPropertyItem({
    required String label,
    required String value,
    required String subtitle,
    required bool isDark,
    bool isAddress = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              style: GoogleFonts.openSans(
                fontSize: isAddress ? 16 : 14,
                fontWeight: FontWeight.normal,
                color: isAddress
                    ? AppColorSchemes.getTextColor(isDark)
                    : AppColorSchemes.greysMidGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPropertyItemWithAction({
    required String label,
    required String value,
    required String subtitle,
    required bool isDark,
    required IconData icon,
    required VoidCallback onIconPressed,
    bool isAddress = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColorSchemes.getTextColor(isDark),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF333333) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    icon,
                    size: 20,
                    color:
                        isDark ? Colors.white : AppColorSchemes.greysDarkGrey,
                  ),
                  onPressed: onIconPressed,
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              style: GoogleFonts.openSans(
                fontSize: isAddress ? 16 : 14,
                fontWeight: FontWeight.normal,
                color: isAddress
                    ? AppColorSchemes.getTextColor(isDark)
                    : AppColorSchemes.greysMidGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTitleSection(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _currentAlias,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.normal,
                color: textColor,
                height: 1.25,
              ),
            ),
          ),
          // Edit Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                M3Icons.edit,
                size: 24,
                color: isDark
                    ? AppColorSchemes.darkTextPrimary
                    : AppColorSchemes.greysDarkGrey,
              ),
              onPressed: _showChangeAliasSheet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColorSchemes.getDividerColor(isDark),
    );
  }

  Widget _buildQRCodeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // QR Code
        Container(
          width: 160,
          height: 160,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Image.asset(
            'assets/img/QR Code.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Create QR-Bill Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.go('/qr-bill');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColorSchemes.darkCardBackground
                  : AppColorSchemes.greysDarkGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  M3Icons.qrCodeScanner,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Create QR-Bill',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
