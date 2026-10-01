import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/icons/m3_icons.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/country/country_repository.dart';

class CountrySelectionSheet extends StatefulWidget {
  final String selectedCountry;
  final ValueChanged<String> onCountrySelected;

  const CountrySelectionSheet({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<CountrySelectionSheet> createState() => _CountrySelectionSheetState();
}

class _CountrySelectionSheetState extends State<CountrySelectionSheet> {
  final TextEditingController _searchController = TextEditingController();

  List<String> _allCountries = const [];
  List<String> _filteredCountries = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final countries = await CountryRepository.loadCountries();
    if (!mounted) return;
    setState(() {
      _allCountries = countries;
      _filteredCountries = countries;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredCountries = _allCountries;
      });
      return;
    }

    setState(() {
      _filteredCountries = _allCountries
          .where((country) => country.toLowerCase().contains(query))
          .toList();
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
          _buildHandle(),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: _buildSearchField(isDark),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Country',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildCountryList(isDark),
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

  Widget _buildSearchField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF333333) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          border: InputBorder.none,
          prefixIcon: Icon(
            M3Icons.search,
            color: AppColorSchemes.greysMidGrey,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.greysMidGrey,
          ),
        ),
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColorSchemes.getTextColor(isDark),
        ),
      ),
    );
  }

  Widget _buildCountryList(bool isDark) {
    if (_filteredCountries.isEmpty) {
      return const Center(
        child: Text(
          'No countries found',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.greysMidGrey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: 56,
      ),
      itemCount: _filteredCountries.length,
      itemBuilder: (context, index) {
        final country = _filteredCountries[index];
        final isSelected = country == widget.selectedCountry;

        return _buildCountryTile(country, isSelected, isDark);
      },
    );
  }

  Widget _buildCountryTile(String country, bool isSelected, bool isDark) {
    final backgroundColor = isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : Colors.transparent;
    final textColor = AppColorSchemes.getTextColor(isDark);
    final checkColor = isDark
        ? AppColorSchemes.primaryDarkYellow
        : AppColorSchemes.greysDarkGrey;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => widget.onCountrySelected(country),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  country,
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
