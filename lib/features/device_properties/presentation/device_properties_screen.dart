import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/icons/m3_icons.dart';
import '../../../../ui/components/bottom_navigation/app_bottom_navigation.dart';

class DevicePropertiesScreen extends StatefulWidget {
  const DevicePropertiesScreen({super.key});

  @override
  State<DevicePropertiesScreen> createState() => _DevicePropertiesScreenState();
}

class _DevicePropertiesScreenState extends State<DevicePropertiesScreen> {
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
                    // Title with Edit Button
                    _buildTitleSection(isDark),

                    // Divider
                    _buildDivider(isDark),

                    // Platform
                    _buildPropertyItem(
                      label: 'Plattform',
                      value: 'IOS',
                      subtitle: 'Clearing Number 761',
                      isDark: isDark,
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // Is this device a tablet
                    _buildPropertyItem(
                      label: 'Is this device a tablet',
                      value: 'No',
                      subtitle: 'Clearing Number 761',
                      isDark: isDark,
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // Does this device have a camera
                    _buildPropertyItem(
                      label: 'Does this device have a camera',
                      value: 'Yes',
                      subtitle: 'Clearing Number 761',
                      isDark: isDark,
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // Device Name
                    _buildPropertyItem(
                      label: 'Device Name',
                      value: 'iPhone',
                      subtitle: 'Clearing Number 761',
                      isDark: isDark,
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // Device ID
                    _buildPropertyItem(
                      label: 'Device ID',
                      value: 'c2e7c224-3544-497c-ac83-53cd93c803',
                      subtitle: 'Clearing Number 761',
                      isDark: isDark,
                    ),

                    // Divider
                    _buildDivider(isDark),

                    // CLX TEST Version
                    _buildPropertyItem(
                      label: 'CLX TEST Version',
                      value: '4.1.143',
                      subtitle: 'Clearing Number 761',
                      isDark: isDark,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Delete device button
                    _buildDeleteButton(),

                    const SizedBox(height: 56),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const AppBottomNavigation(activeRoute: '/device-properties'),
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
        ),
        onPressed: () => context.go('/settings'),
      ),
    );
  }

  Widget _buildTitleSection(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final cardColor = AppColorSchemes.getCardBackgroundColor(isDark);
    final iconColor = AppColorSchemes.greysDarkGrey;

    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'FaysIphone',
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
                color: isDark ? AppColorSchemes.darkTextPrimary : iconColor,
              ),
              onPressed: () {
                // Handle edit
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyItem({
    required String label,
    required String value,
    required String subtitle,
    required bool isDark,
  }) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      constraints: const BoxConstraints(
        minHeight: 77,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (Bold, 14px)
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Value (Regular, 16px)
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Subtitle (Regular, 14px, gray)
          Text(
            subtitle,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColorSchemes.greysMidGrey,
              height: 1.5,
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

  Widget _buildDeleteButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysDarkGrey, // #333333
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // Handle delete device
        },
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            'Delete device',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
