import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/icons/m3_icons.dart';

class LoginSettingsScreen extends StatefulWidget {
  const LoginSettingsScreen({super.key});

  @override
  State<LoginSettingsScreen> createState() => _LoginSettingsScreenState();
}

class _LoginSettingsScreenState extends State<LoginSettingsScreen> {
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
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.md,
                        bottom: AppSpacing.md,
                      ),
                      child: Text(
                        'Login Settings',
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: isDark
                              ? AppColorSchemes.darkTextPrimary
                              : AppColorSchemes.greysDarkGrey,
                          height: 1.25,
                        ),
                      ),
                    ),

                    // Add Contract
                    _buildMenuItem(
                      icon: M3Icons.addSimple,
                      title: 'Add Contract',
                      isDark: isDark,
                    ),

                    // Manage Contracts
                    _buildMenuItem(
                      icon: M3Icons.description,
                      title: 'Manage Contracts',
                      isDark: isDark,
                    ),

                    // Forgotten PIN
                    _buildMenuItem(
                      icon: M3Icons.settingsBackupRestore,
                      title: 'Forgotten PIN',
                      isDark: isDark,
                    ),

                    // Change PIN
                    _buildMenuItem(
                      icon: M3Icons.pattern,
                      title: 'Change PIN',
                      isDark: isDark,
                    ),

                    // Biometric Login Settings
                    _buildMenuItem(
                      icon: M3Icons.fingerprint,
                      title: 'Biometric Login Settings',
                      isDark: isDark,
                    ),

                    // Send Diagnostics
                    _buildMenuItem(
                      icon: M3Icons.insertChartOutlined,
                      title: 'Send Diagnostics',
                      isDark: isDark,
                    ),

                    // Device Properties
                    InkWell(
                      onTap: () => context.go('/device-properties'),
                      child: _buildMenuItem(
                        icon: M3Icons.permDeviceInformation,
                        title: 'Device Properties',
                        isDark: isDark,
                      ),
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // Help
                    _buildMenuItem(
                      icon: M3Icons.helpOutline,
                      title: 'Help',
                      isDark: isDark,
                    ),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
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
          color: isDark
              ? AppColorSchemes.darkTextPrimary
              : AppColorSchemes.greysDarkGrey,
        ),
        onPressed: () => context.go('/login-existing-user'),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    final textColor = isDark
        ? AppColorSchemes.darkTextPrimary
        : AppColorSchemes.greysDarkGrey;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 64,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          // Icon
          SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              icon,
              size: 24,
              color: textColor,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Title
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColorSchemes.getDividerColor(isDark),
      ),
    );
  }
}
