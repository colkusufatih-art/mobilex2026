import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/icons/m3_icons.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';

class AddressSelectionSheet extends StatelessWidget {
  final String selectedAddress;
  final ValueChanged<String> onAddressSelected;

  const AddressSelectionSheet({
    super.key,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final addresses = _addressData;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColorSchemes.darkBackground
            : AppColorSchemes.lightBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recipient's Address",
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: _buildAddressList(addresses, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 35,
      height: 5,
      decoration: BoxDecoration(
        color: AppColorSchemes.greysMidGrey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildAddressList(List<AddressData> addresses, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: 56,
      ),
      itemBuilder: (context, index) {
        final address = addresses[index];
        final isSelected = address.address == selectedAddress;

        return _buildAddressCard(address, isSelected, isDark);
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemCount: addresses.length,
    );
  }

  Widget _buildAddressCard(
      AddressData address, bool isSelected, bool isDark) {
    final cardColor = isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : AppColorSchemes.getCardBackgroundColor(isDark);
    final textColor = AppColorSchemes.getTextColor(isDark);
    final checkColor = isDark
        ? AppColorSchemes.primaryDarkYellow
        : AppColorSchemes.greysDarkGrey;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => onAddressSelected(address.address),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  address.address,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  M3Icons.check,
                  size: 24,
                  color: checkColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressData {
  final String address;

  const AddressData({
    required this.address,
  });
}

final List<AddressData> _addressData = [
  const AddressData(
    address: 'Römerstrasse 36C, 5400 Baden (CH)',
  ),
  const AddressData(
    address: 'Maneggstrasse 17, 8105 Zürich (CH)',
  ),
  const AddressData(
    address: 'Spindelstrasse 20, 8105 Zürich (CH)',
  ),
  const AddressData(
    address: 'Zwirnerstrasse 52, 8105 Zürich (CH)',
  ),
];
