import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart';
import '../domain/account_transfer_draft.dart';

class ConfirmAccountTransferScreen extends StatelessWidget {
  final AccountTransferDraft draft;
  const ConfirmAccountTransferScreen({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;

    final content = _buildContent(context, isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(isDark: isDark, draft: draft),
            Divider(
              color: isDark
                  ? AppColorSchemes.darkCardBackground
                  : const Color(0xFFDADADA),
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  ...content,
                  const SizedBox(height: AppSpacing.xl),
                  AppFilledButton(
                    text: 'Execute Account Transfer',
                    onPressed: () {
                      context.go(
                        '/payments/account-transfer-confirmed',
                        extra: draft,
                      );
                    },
                  ),
                  const SizedBox(height: 56),
                ],
              ),
            ),
            const AppBottomNavigation(activeRoute: '/payments'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool isDark) {
    final entries = _buildEntries(context, isDark);
    final widgets = <Widget>[const SizedBox(height: AppSpacing.md)];

    for (final entry in entries) {
      widgets.add(ValueListElement(entry: entry, isDark: isDark));
      if (_needsDividerAfter(entry.label)) {
        widgets.add(_sectionDivider(isDark));
      }
    }

    return widgets;
  }

  List<ValueListEntry> _buildEntries(BuildContext context, bool isDark) {
    final entries = <ValueListEntry>[
      ValueListEntry(
        label: 'Debit Account',
        value: draft.fromAccount.isNotEmpty ? draft.fromAccount : '—',
        trailingAction: _editAction(
          context,
          () => context.go(
            '/payments/account-transfer',
            extra: draft,
          ),
          isDark,
        ),
      ),
      ValueListEntry(
        label: 'Amount',
        value: draft.formattedAmount,
        trailingAction: _editAction(
          context,
          () => context.go(
            '/payments/account-transfer',
            extra: draft,
          ),
          isDark,
        ),
      ),
      ValueListEntry(
        label: 'Credit Account',
        value: draft.toAccount.isNotEmpty ? draft.toAccount : '—',
        trailingAction: _editAction(
          context,
          () => context.go(
            '/payments/account-transfer',
            extra: draft,
          ),
          isDark,
        ),
      ),
      ValueListEntry(
        label: 'Execution date',
        value: draft.formatDate(draft.executionDate),
      ),
    ];

    if (draft.reference.isNotEmpty) {
      entries.add(
        ValueListEntry(
          label: 'Reference',
          value: draft.reference,
        ),
      );
    }

    if (draft.purposeOfPayment.isNotEmpty) {
      entries.add(
        ValueListEntry(
          label: 'Purpose of payment',
          value: draft.purposeOfPayment,
        ),
      );
    }

    entries.addAll([
      ValueListEntry(
        label: 'Debit note',
        value: draft.debitNote,
      ),
      ValueListEntry(
        label: 'Personal note',
        value: draft.personalNote.isNotEmpty ? draft.personalNote : '—',
      ),
    ]);

    if (draft.standingOrderEnabled) {
      entries.add(
        ValueListEntry(
          label: 'Standing Order',
          value: 'Yes',
          trailingAction: _editAction(
            context,
            () => context.go(
              '/payments/account-transfer',
              extra: draft,
            ),
            isDark,
          ),
        ),
      );

      entries.addAll([
        ValueListEntry(
          label: 'Holiday',
          value: draft.standingHoliday,
        ),
        ValueListEntry(
          label: 'First Execution',
          value: draft.formatDate(draft.standingFirstExecution),
        ),
      ]);

      if (draft.standingValidity == 'Last execution date') {
        entries.add(
          ValueListEntry(
            label: 'Last Execution',
            value: draft.formatDate(draft.standingLastExecution),
          ),
        );
      } else if (draft.standingValidity == 'Number of executions' &&
          draft.standingExecutions.isNotEmpty) {
        entries.add(
          ValueListEntry(
            label: 'Number of executions',
            value: draft.standingExecutions,
          ),
        );
      }
    }

    return entries;
  }

  bool _needsDividerAfter(String label) {
    return label == 'Debit Account' ||
        label == 'Amount' ||
        (label == 'Personal note' && draft.standingOrderEnabled);
  }

  Widget _sectionDivider(bool isDark) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Divider(
          color: isDark
              ? AppColorSchemes.darkCardBackground
              : const Color(0xFFDADADA),
          height: 1,
          thickness: 1,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _editAction(
    BuildContext context,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF333333) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.edit,
          size: 24,
          color: isDark ? Colors.white : const Color(0xFF333333),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;
  final AccountTransferDraft draft;
  const _Header({required this.isDark, required this.draft});

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);
    return Material(
      color: isDark
          ? AppColorSchemes.darkBackground
          : AppColorSchemes.lightBackground,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => context.go(
                '/payments/account-transfer',
                extra: draft,
              ),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back,
                  color: textColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Transfer Summary',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => context.go('/payments'),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: textColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

