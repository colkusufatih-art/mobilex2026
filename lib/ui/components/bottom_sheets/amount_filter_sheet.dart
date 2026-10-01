import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../ui/components/inputs/amount_field.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// Amount Filter Bottom Sheet
///
/// Bottom sheet for selecting an amount range filter with From and To inputs
class AmountFilterSheet extends StatefulWidget {
  final String selectedAmountRange;
  final Function(String) onAmountRangeSelected;

  const AmountFilterSheet({
    super.key,
    required this.selectedAmountRange,
    required this.onAmountRangeSelected,
  });

  @override
  State<AmountFilterSheet> createState() => _AmountFilterSheetState();
}

class _AmountFilterSheetState extends State<AmountFilterSheet> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    // Parse existing range if available (format: "100-200")
    String fromValue = '';
    String toValue = '';
    if (widget.selectedAmountRange.isNotEmpty) {
      final parts = widget.selectedAmountRange.split('-');
      if (parts.length == 2) {
        fromValue = parts[0].trim();
        toValue = parts[1].trim();
      }
    }
    _fromController = TextEditingController(text: fromValue);
    _toController = TextEditingController(text: toValue);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    
    String range = '';
    if (from.isNotEmpty && to.isNotEmpty) {
      range = '$from-$to';
    } else if (from.isNotEmpty) {
      range = 'From $from';
    } else if (to.isNotEmpty) {
      range = 'To $to';
    }
    
    widget.onAmountRangeSelected(range);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          // Handle
          _buildHandle(isDark),

          // Header
          _buildHeader(isDark),

          // Input Fields
          Flexible(
            child: _buildInputFields(isDark),
          ),

          // Search Button
          _buildSearchButton(isDark),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
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

  Widget _buildHeader(bool isDark) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Amount',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Column(
        children: [
          // From Input
          AmountField(
            label: 'From',
            hintText: 'From',
            controller: _fromController,
            isDark: isDark,
            onChanged: (value) {
              setState(() {});
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // To Input
          AmountField(
            label: 'To',
            hintText: 'To',
            controller: _toController,
            isDark: isDark,
            onChanged: (value) {
              setState(() {});
            },
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSearchButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: 56,
      ),
      child: AppFilledButton(
        text: 'Search',
        onPressed: _applyFilter,
      ),
    );
  }
}