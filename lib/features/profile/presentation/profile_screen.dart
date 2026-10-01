import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/icons/m3_icons.dart';
import '../../../ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart' show ValueListElement, ValueListEntry;

/// Profile Screen
///
/// Displays user profile information including personal data, address, and contract number
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _street = 'Maneggstrasse 17';
  String _postcode = '8105';
  String _city = 'Zürich';
  String _country = 'Switzerland';

  String get _addressValue {
    return '$_street\n$_postcode $_city\n$_country';
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
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Profile',
                          style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: AppColorSchemes.getTextColor(isDark),
                            height: 1.25,
                          ),
                        ),
                      ),

                      // Personal data
                      ValueListElement(
                        entry: ValueListEntry(
                          label: 'Personal data',
                          value: 'Mr.\nReto Haldner\n02.08.1980',
                        ),
                        isDark: isDark,
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: isDark
                              ? AppColorSchemes.darkCardBackground
                              : AppColorSchemes.greysLightGrey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),

                      // Address
                      ValueListElement(
                        entry: ValueListEntry(
                          label: 'Address',
                          value: _addressValue,
                          trailingAction: _buildEditButton(context, isDark),
                        ),
                        isDark: isDark,
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: isDark
                              ? AppColorSchemes.darkCardBackground
                              : AppColorSchemes.greysLightGrey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),

                      // Contract number
                      ValueListElement(
                        entry: ValueListEntry(
                          label: 'Contractnumber',
                          value: '492734923233',
                        ),
                        isDark: isDark,
                      ),

                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              const AppBottomNavigation(activeRoute: '/more'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.go('/more'),
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
          const SizedBox(width: 40), // Balance width
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    final bgColor = AppColorSchemes.getCardBackgroundColor(isDark);

    return InkWell(
      onTap: () async {
        final result = await context.push(
          '/profile/edit-address',
          extra: {
            'initialStreet': _street,
            'initialPostcode': _postcode,
            'initialCity': _city,
            'initialCountry': _country,
          },
        );
        
        if (result != null && result is Map<String, String>) {
          setState(() {
            _street = result['street'] ?? _street;
            _postcode = result['postcode'] ?? _postcode;
            _city = result['city'] ?? _city;
            _country = result['country'] ?? _country;
          });
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          M3Icons.edit,
          color: textColor,
          size: 24,
        ),
      ),
    );
  }
}

