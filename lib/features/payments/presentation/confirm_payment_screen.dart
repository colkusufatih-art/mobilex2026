import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import 'package:mobilex2025/ui/components/buttons/app_filled_button.dart';
import '../../transaction_detail/presentation/transaction_detail_screen.dart';
import '../domain/payment_draft.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  final PaymentDraft draft;
  const ConfirmPaymentScreen({super.key, required this.draft});

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
            _Header(isDark: isDark),
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
                    text: 'Confirm payment',
                    onPressed: () {
                      context.go(
                        '/payments/payment-confirmed',
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
        label: 'Recipient',
        value: draft.recipientSummary.isNotEmpty ? draft.recipientSummary : '—',
        trailingAction: _editAction(
          context,
          () => context.go(
            '/payments/payment-progress-step-1',
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
            '/payments/payment-progress-step-2',
            extra: draft,
          ),
          isDark,
        ),
      ),
      ValueListEntry(
        label: 'Debit Account',
        value: draft.selectedAccount,
        trailingAction: _editAction(
          context,
          () => context.go(
            '/payments/payment-progress-step-3',
            extra: draft,
          ),
          isDark,
        ),
      ),
      ValueListEntry(
        label: 'Execution date',
        value: draft.formatDate(draft.executionDate),
      ),
      ValueListEntry(
        label: 'Fees',
        value: draft.fees,
      ),
    ];

    if (draft.recipientReference.isNotEmpty) {
      entries.add(
        ValueListEntry(
          label: 'Reference',
          value: draft.recipientReference,
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

    if (draft.yourReference.isNotEmpty) {
      entries.add(
        ValueListEntry(
          label: 'Personal note',
          value: draft.yourReference,
        ),
      );
    }

    entries.addAll([
      ValueListEntry(
        label: 'Debit note',
        value: draft.debitNote,
      ),
      ValueListEntry(
        label: 'Confidental',
        value: draft.confidential,
      ),
      ValueListEntry(
        label: 'Urgency',
        value: draft.urgency,
      ),
      ValueListEntry(
        label: 'Standing Order',
        value: draft.standingOrderEnabled ? 'Yes' : 'No',
        trailingAction: _editAction(
          context,
          () => context.go(
            '/payments/payment-progress-step-3',
            extra: draft,
          ),
          isDark,
        ),
      ),
    ]);

    if (draft.standingOrderEnabled) {
      entries.addAll([
        ValueListEntry(
          label: 'Periodicity',
          value: draft.standingRepeat,
        ),
        ValueListEntry(
          label: 'Holiday',
          value: draft.standingHoliday,
        ),
        ValueListEntry(
          label: 'First Execution',
          value: draft.formatDate(draft.firstExecutionDate),
        ),
        ValueListEntry(
          label: 'Validity',
          value: draft.validity,
        ),
      ]);

      if (draft.validity == 'Number of executions' &&
          draft.numberOfExecutions.isNotEmpty) {
        entries.add(
          ValueListEntry(
            label: 'Number of executions',
            value: draft.numberOfExecutions,
          ),
        );
      }

      if (draft.validity == 'Last execution date') {
        entries.add(
          ValueListEntry(
            label: 'Last Execution',
            value: draft.formatDate(draft.lastExecutionDate),
          ),
        );
      }
    }

    return entries;
  }

  bool _needsDividerAfter(String label) {
    return label == 'Recipient' ||
        label == 'Amount' ||
        label == 'Urgency';
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
  const _Header({required this.isDark});

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
              onTap: () => context.pop(),
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
                'Confirm payment',
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
