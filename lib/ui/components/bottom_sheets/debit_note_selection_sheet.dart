import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/icons/m3_icons.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';

class DebitNoteSelectionSheet extends StatelessWidget {
  final String selectedDebitNote;
  final ValueChanged<String> onDebitNoteSelected;

  const DebitNoteSelectionSheet({
    super.key,
    required this.selectedDebitNote,
    required this.onDebitNoteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const debitNotes = ['Standard', 'Single display'];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
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
                'Debit note',
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
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: 56,
              ),
              itemBuilder: (context, index) {
                final debitNote = debitNotes[index];
                final isSelected = debitNote == selectedDebitNote;

                return _buildDebitNoteCard(debitNote, isSelected, isDark);
              },
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemCount: debitNotes.length,
            ),
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

  Widget _buildDebitNoteCard(String debitNote, bool isSelected, bool isDark) {
    final backgroundColor = isSelected
        ? AppColorSchemes.primaryDarkYellow.withValues(alpha: 0.3)
        : AppColorSchemes.getCardBackgroundColor(isDark);
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
        onTap: () => onDebitNoteSelected(debitNote),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  debitNote,
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

