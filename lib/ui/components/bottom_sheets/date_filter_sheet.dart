import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/spacing.dart';
import '../../../ui/components/inputs/app_input_field.dart';
import '../../../ui/components/buttons/app_filled_button.dart';

/// Date Filter Bottom Sheet
///
/// Bottom sheet for selecting a date range filter with From and To date pickers
class DateFilterSheet extends StatefulWidget {
  final String selectedDateRange;
  final Function(String) onDateRangeSelected;

  const DateFilterSheet({
    super.key,
    required this.selectedDateRange,
    required this.onDateRangeSelected,
  });

  @override
  State<DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<DateFilterSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedPreset;

  @override
  void initState() {
    super.initState();
    // Parse existing range if available
    // Format could be "01.01.2025 - 31.01.2025" or preset name
    if (widget.selectedDateRange.isNotEmpty) {
      if (widget.selectedDateRange.contains(' - ')) {
        final parts = widget.selectedDateRange.split(' - ');
        if (parts.length == 2) {
          _fromDate = _parseDate(parts[0].trim());
          _toDate = _parseDate(parts[1].trim());
        }
      }
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('dd.MM.yyyy').parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Future<void> _pickDate({
    required String title,
    required DateTime? initialDate,
    required Function(DateTime) onSelected,
  }) async {
    final now = DateTime.now();
    final baseTheme = Theme.of(context);
    final isDark = baseTheme.brightness == Brightness.dark;
    final textColor = AppColorSchemes.getTextColor(isDark);
    final subtleTextColor = AppColorSchemes.getTextLightColor(isDark);
    final accentColor = AppColorSchemes.primaryDarkYellow;
    final backgroundColor =
        isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final headerBackground =
        isDark ? AppColorSchemes.darkBackground : Colors.white;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      helpText: title,
      builder: (context, child) {
        final ColorScheme colorScheme =
            isDark ? AppColorSchemes.dark : AppColorSchemes.light;

        Color? resolveDayForeground(Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return subtleTextColor.withValues(alpha: 0.4);
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textColor;
        }

        Color? resolveDayBackground(Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return Colors.transparent;
        }

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: backgroundColor,
              onSurface: textColor,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: headerBackground,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: headerBackground,
              headerForegroundColor: textColor,
              dayForegroundColor: WidgetStateProperty.resolveWith(resolveDayForeground),
              dayBackgroundColor: WidgetStateProperty.resolveWith(resolveDayBackground),
              todayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return accentColor;
              }),
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return accentColor;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  void _applyFilter() {
    String range = '';
    if (_selectedPreset != null) {
      range = _selectedPreset!;
    } else if (_fromDate != null && _toDate != null) {
      range = '${_formatDate(_fromDate!)} - ${_formatDate(_toDate!)}';
    } else if (_fromDate != null) {
      range = 'From ${_formatDate(_fromDate!)}';
    } else if (_toDate != null) {
      range = 'To ${_formatDate(_toDate!)}';
    }

    widget.onDateRangeSelected(range);
    Navigator.of(context).pop();
  }

  void _selectPreset(String preset) {
    setState(() {
      _selectedPreset = preset;
      // Clear date selection when preset is selected
      _fromDate = null;
      _toDate = null;

      // Apply preset dates
      final now = DateTime.now();
      switch (preset) {
        case 'Current Month':
          _fromDate = DateTime(now.year, now.month, 1);
          _toDate = DateTime(now.year, now.month + 1, 0);
          break;
        case '3 Months':
          _fromDate = DateTime(now.year, now.month - 2, 1);
          _toDate = now;
          break;
        case '6 Months':
          _fromDate = DateTime(now.year, now.month - 5, 1);
          _toDate = now;
          break;
        case 'Current year':
          _fromDate = DateTime(now.year, 1, 1);
          _toDate = now;
          break;
        case 'Last 2 years':
          _fromDate = DateTime(now.year - 2, 1, 1);
          _toDate = now;
          break;
      }
    });
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

          // Input Fields and Presets
          Flexible(
            child: _buildContent(isDark),
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
            'Date',
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

  Widget _buildContent(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From Date Picker
          AppInputField(
            label: 'From',
            value: _fromDate != null ? _formatDate(_fromDate!) : null,
            hintText: 'From',
            state: _fromDate != null ? InputFieldState.filled : InputFieldState.defaultValue,
            isDark: isDark,
            isDropdown: true,
            showFloatingLabel: false,
            trailingIcon: Icons.calendar_today,
            trailingIconColor: AppColorSchemes.getTextColor(isDark),
            onTap: () => _pickDate(
              title: 'From',
              initialDate: _fromDate,
              onSelected: (date) {
                setState(() {
                  _fromDate = date;
                  _selectedPreset = null; // Clear preset when manual date is selected
                });
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // To Date Picker
          AppInputField(
            label: 'To',
            value: _toDate != null ? _formatDate(_toDate!) : null,
            hintText: 'To',
            state: _toDate != null ? InputFieldState.filled : InputFieldState.defaultValue,
            isDark: isDark,
            isDropdown: true,
            showFloatingLabel: false,
            trailingIcon: Icons.calendar_today,
            trailingIconColor: AppColorSchemes.getTextColor(isDark),
            onTap: () => _pickDate(
              title: 'To',
              initialDate: _toDate ?? _fromDate,
              onSelected: (date) {
                setState(() {
                  _toDate = date;
                  _selectedPreset = null; // Clear preset when manual date is selected
                });
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Presets Section
          Text(
            'Presets',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Preset Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Current Month',
              '3 Months',
              '6 Months',
              'Current year',
              'Last 2 years',
            ].map((preset) => _buildPresetChip(preset, isDark)).toList(),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String preset, bool isDark) {
    final isSelected = _selectedPreset == preset;
    final textColor = AppColorSchemes.getTextColor(isDark);

    return InkWell(
      onTap: () => _selectPreset(preset),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
              : AppColorSchemes.getCardBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          preset,
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.1,
          ),
        ),
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
