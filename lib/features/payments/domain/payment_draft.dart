import 'package:intl/intl.dart';

class PaymentDraft {
  final String iban;
  final String recipientName;
  final String addressLine1;
  final String addressLine2;
  final String postCode;
  final String city;
  final String country;
  final String recipientReference;
  final String purposeOfPayment;
  final bool instantPayment;
  final bool ultimateDebtorEnabled;
  final String ultimateDebtorName;
  final String ultimateDebtorAddress;
  final String ultimateDebtorHouseNumber;
  final String ultimateDebtorPostCode;
  final String ultimateDebtorCity;
  final String ultimateDebtorCountry;
  final String amount;
  final String currency;
  final String selectedAccount;
  final String yourReference;
  final String debitNote;
  final String confidential;
  final String urgency;
  final String fees;
  final DateTime executionDate;
  final bool standingOrderEnabled;
  final String standingRepeat;
  final String standingDay;
  final String standingHoliday;
  final DateTime firstExecutionDate;
  final String validity;
  final String numberOfExecutions;
  final DateTime lastExecutionDate;

  PaymentDraft({
    this.iban = '',
    this.recipientName = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.postCode = '',
    this.city = '',
    this.country = '',
    this.recipientReference = '',
    this.purposeOfPayment = '',
    this.instantPayment = false,
    this.ultimateDebtorEnabled = false,
    this.ultimateDebtorName = '',
    this.ultimateDebtorAddress = '',
    this.ultimateDebtorHouseNumber = '',
    this.ultimateDebtorPostCode = '',
    this.ultimateDebtorCity = '',
    this.ultimateDebtorCountry = 'Switzerland',
    this.amount = '',
    this.currency = 'CHF',
    this.selectedAccount =
        'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nCHF 4’323.30',
    this.yourReference = '',
    this.debitNote = 'Standard',
    this.confidential = 'No',
    this.urgency = 'High',
    this.fees = 'Shared fees',
    DateTime? executionDate,
    this.standingOrderEnabled = false,
    this.standingRepeat = 'Monthly',
    this.standingDay = 'Specific day',
    this.standingHoliday = 'Before the holiday',
    DateTime? firstExecutionDate,
    this.validity = 'Until revoked',
    this.numberOfExecutions = '',
    DateTime? lastExecutionDate,
  })  : executionDate = executionDate ?? DateTime.now(),
        firstExecutionDate = firstExecutionDate ?? DateTime.now(),
        lastExecutionDate = lastExecutionDate ?? DateTime.now();

  PaymentDraft copyWith({
    String? iban,
    String? recipientName,
    String? addressLine1,
    String? addressLine2,
    String? postCode,
    String? city,
    String? country,
    String? recipientReference,
    String? purposeOfPayment,
    String? amount,
    bool? instantPayment,
    bool? ultimateDebtorEnabled,
    String? ultimateDebtorName,
    String? ultimateDebtorAddress,
    String? ultimateDebtorHouseNumber,
    String? ultimateDebtorPostCode,
    String? ultimateDebtorCity,
    String? ultimateDebtorCountry,
    String? currency,
    String? selectedAccount,
    String? yourReference,
    String? debitNote,
    String? confidential,
    String? urgency,
    String? fees,
    DateTime? executionDate,
    bool? standingOrderEnabled,
    String? standingRepeat,
    String? standingDay,
    String? standingHoliday,
    DateTime? firstExecutionDate,
    String? validity,
    String? numberOfExecutions,
    DateTime? lastExecutionDate,
  }) {
    return PaymentDraft(
      iban: iban ?? this.iban,
      recipientName: recipientName ?? this.recipientName,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      country: country ?? this.country,
      recipientReference: recipientReference ?? this.recipientReference,
      purposeOfPayment: purposeOfPayment ?? this.purposeOfPayment,
      instantPayment: instantPayment ?? this.instantPayment,
      ultimateDebtorEnabled:
          ultimateDebtorEnabled ?? this.ultimateDebtorEnabled,
      ultimateDebtorName: ultimateDebtorName ?? this.ultimateDebtorName,
      ultimateDebtorAddress: ultimateDebtorAddress ?? this.ultimateDebtorAddress,
      ultimateDebtorHouseNumber:
          ultimateDebtorHouseNumber ?? this.ultimateDebtorHouseNumber,
      ultimateDebtorPostCode:
          ultimateDebtorPostCode ?? this.ultimateDebtorPostCode,
      ultimateDebtorCity: ultimateDebtorCity ?? this.ultimateDebtorCity,
      ultimateDebtorCountry:
          ultimateDebtorCountry ?? this.ultimateDebtorCountry,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      yourReference: yourReference ?? this.yourReference,
      debitNote: debitNote ?? this.debitNote,
      confidential: confidential ?? this.confidential,
      urgency: urgency ?? this.urgency,
      fees: fees ?? this.fees,
      executionDate: executionDate ?? this.executionDate,
      standingOrderEnabled: standingOrderEnabled ?? this.standingOrderEnabled,
      standingRepeat: standingRepeat ?? this.standingRepeat,
      standingDay: standingDay ?? this.standingDay,
      standingHoliday: standingHoliday ?? this.standingHoliday,
      firstExecutionDate: firstExecutionDate ?? this.firstExecutionDate,
      validity: validity ?? this.validity,
      numberOfExecutions: numberOfExecutions ?? this.numberOfExecutions,
      lastExecutionDate: lastExecutionDate ?? this.lastExecutionDate,
    );
  }

  String get formattedAmount {
    if (amount.isEmpty) {
      return '$currency 0.00';
    }
    return '$currency $amount';
  }

  String get recipientSummary =>
      _formatAddressBlock(recipientName, addressLine1, addressLine2, postCode,
          city, country, iban);

  String get ultimateDebtorSummary => _formatAddressBlock(
        ultimateDebtorName,
        ultimateDebtorAddress,
        ultimateDebtorHouseNumber,
        ultimateDebtorPostCode,
        ultimateDebtorCity,
        ultimateDebtorCountry,
      );

  String _formatAddressBlock(
    String name,
    String address,
    String houseNumber,
    String postCode,
    String city,
    String country, [
    String iban = '',
  ]) {
    final lines = <String>[
      if (name.isNotEmpty) name,
      if (iban.isNotEmpty) iban,
      [
        if (address.isNotEmpty) address,
        if (houseNumber.isNotEmpty) houseNumber,
      ].where((element) => element.isNotEmpty).join(' '),
      [
        if (postCode.isNotEmpty) postCode,
        if (city.isNotEmpty) city,
      ].where((element) => element.isNotEmpty).join(' '),
      if (country.isNotEmpty) country,
    ].where((element) => element.isNotEmpty).toList();

    return lines.join('\n');
  }

  String formatDate(DateTime date) =>
      DateFormat('dd.MM.yyyy').format(date.toLocal());
}

