import 'package:intl/intl.dart';

class AccountTransferDraft {
  final String fromAccount;
  final String toAccount;
  final String currency;
  final String amount;
  final DateTime executionDate;
  final String reference;
  final String purposeOfPayment;
  final String debitNote;
  final String personalNote;
  final bool standingOrderEnabled;
  final String standingRepeat;
  final String standingDay;
  final String standingHoliday;
  final DateTime standingFirstExecution;
  final String standingValidity;
  final String standingExecutions;
  final DateTime standingLastExecution;

  AccountTransferDraft({
    this.fromAccount = '',
    this.toAccount = '',
    this.currency = 'CHF',
    this.amount = '',
    DateTime? executionDate,
    this.reference = '',
    this.purposeOfPayment = '',
    this.debitNote = 'Standard',
    this.personalNote = '',
    this.standingOrderEnabled = false,
    this.standingRepeat = 'Monthly',
    this.standingDay = 'Specific day',
    this.standingHoliday = 'Before the holiday',
    DateTime? standingFirstExecution,
    this.standingValidity = 'Until revoked',
    this.standingExecutions = '',
    DateTime? standingLastExecution,
  })  : executionDate = executionDate ?? DateTime.now(),
        standingFirstExecution =
            standingFirstExecution ?? DateTime.now(),
        standingLastExecution =
            standingLastExecution ?? DateTime.now();

  AccountTransferDraft copyWith({
    String? fromAccount,
    String? toAccount,
    String? currency,
    String? amount,
    DateTime? executionDate,
    String? reference,
    String? purposeOfPayment,
    String? debitNote,
    String? personalNote,
    bool? standingOrderEnabled,
    String? standingRepeat,
    String? standingDay,
    String? standingHoliday,
    DateTime? standingFirstExecution,
    String? standingValidity,
    String? standingExecutions,
    DateTime? standingLastExecution,
  }) {
    return AccountTransferDraft(
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      executionDate: executionDate ?? this.executionDate,
      reference: reference ?? this.reference,
      purposeOfPayment: purposeOfPayment ?? this.purposeOfPayment,
      debitNote: debitNote ?? this.debitNote,
      personalNote: personalNote ?? this.personalNote,
      standingOrderEnabled:
          standingOrderEnabled ?? this.standingOrderEnabled,
      standingRepeat: standingRepeat ?? this.standingRepeat,
      standingDay: standingDay ?? this.standingDay,
      standingHoliday: standingHoliday ?? this.standingHoliday,
      standingFirstExecution:
          standingFirstExecution ?? this.standingFirstExecution,
      standingValidity: standingValidity ?? this.standingValidity,
      standingExecutions: standingExecutions ?? this.standingExecutions,
      standingLastExecution:
          standingLastExecution ?? this.standingLastExecution,
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  String get formattedAmount {
    if (amount.isEmpty) return '—';
    return '$currency $amount';
  }
}

