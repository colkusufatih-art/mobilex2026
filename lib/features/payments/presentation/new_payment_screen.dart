import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:mobilex2025/core/icons/m3_icons.dart';
import 'package:mobilex2025/core/theme/color_schemes.dart';
import 'package:mobilex2025/core/theme/radius.dart';
import 'package:mobilex2025/core/theme/spacing.dart';
import 'package:mobilex2025/ui/components/bottom_navigation/app_bottom_navigation.dart';
import '../domain/payment_draft.dart';

class NewPaymentScreen extends StatefulWidget {
  const NewPaymentScreen({super.key});

  @override
  State<NewPaymentScreen> createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  String _searchQuery = '';
  int _currentPageIndex = 0;

  static const _paymentOptions = [
    _PaymentOption(
      title: 'Domestic payment',
      subtitle: 'Enter new domestic payment',
    ),
    _PaymentOption(
      title: 'QR-Bill',
      subtitle: 'Enter new domestic QR-payment',
    ),
    _PaymentOption(
      title: 'Foreign payment',
      subtitle: 'Enter new foreign payment',
    ),
  ];

  static const _recentPayments = [
    _RecentPayment(
      name: 'Martin Wenger',
      amount: 'CHF 50.00',
      reference: 'CH65 8437 7219 8273 2',
      secondaryAmount: '',
    ),
    _RecentPayment(
      name: 'Swisscom Internet',
      amount: 'CHF 50.00',
      reference: 'CH36 4293 0439 8293 7',
      secondaryAmount: '',
    ),
    _RecentPayment(
      name: 'Hannah Braun',
      amount: 'CHF 50.00',
      reference: 'CH43 8493 1832 7564 3',
      secondaryAmount: '',
    ),
    _RecentPayment(
      name: 'Clara Lehmann',
      amount: 'CHF 50.00',
      reference: 'CH43 8493 1832 7564 3',
      secondaryAmount: '',
    ),
    _RecentPayment(
      name: 'Laura Weber',
      amount: 'CHF 50.00',
      reference: 'CH43 8493 1832 7564 3',
      secondaryAmount: '',
    ),
    _RecentPayment(
      name: 'Tim Schneider',
      amount: 'CHF 50.00',
      reference: 'CH43 8493 1832 7564 3',
      secondaryAmount: '',
    ),
    _RecentPayment(
      name: 'Julia Richter',
      amount: 'CHF 50.00',
      reference: 'CH36 4293 0439 8293 7',
      secondaryAmount: '',
    ),
  ];

  List<_RecentPayment> get _filteredPayments {
    if (_searchQuery.trim().length < 3) {
      return _recentPayments;
    }
    final normalizedQuery = _searchQuery.toLowerCase();
    return _recentPayments.where((payment) {
      final name = payment.name.toLowerCase();
      final reference = payment.reference.toLowerCase();
      final amount = payment.amount.toLowerCase();
      return name.contains(normalizedQuery) ||
          reference.contains(normalizedQuery) ||
          amount.contains(normalizedQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _Header(isDark: isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      _SearchField(
                        isDark: isDark,
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                      ),
                      const SizedBox(height: 32),
                      _SectionTitle(
                        label: 'Payment options',
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 81,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          itemCount: _paymentOptions.length,
                          itemBuilder: (context, index) {
                            final option = _paymentOptions[index];
                            final isFirst = index == 0;
                            final isForeignPayment = index == 2;
                            final isQrPayment = index == 1;
                            return Padding(
                              padding: EdgeInsets.only(
                                right:
                                    index < _paymentOptions.length - 1 ? 16 : 0,
                                left: index == 0 ? 0 : 0,
                              ),
                              child: SizedBox(
                                width: 311,
                                child: _PaymentOptionCard(
                                  option: option,
                                  isDark: isDark,
                                  onTap: isFirst
                                      ? () => context.push(
                                            '/payments/payment-progress-step-1',
                                          )
                                      : isQrPayment
                                          ? () => context.push(
                                                '/payments/qr-payment-step-1',
                                              )
                                          : isForeignPayment
                                              ? () => context.push(
                                                    '/payments/foreign-payment-step-1',
                                                  )
                                              : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CarouselBullets(
                        currentIndex: _currentPageIndex,
                        totalCount: _paymentOptions.length,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 32),
                      _SectionTitle(
                        label: 'Last Payments',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 32),
                      if (_filteredPayments.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.lg),
                          child: Text(
                            'No payments found',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColorSchemes.greysMidGrey,
                            ),
                          ),
                        )
                      else
                        ..._filteredPayments.map(
                          (payment) => _RecentPaymentTile(
                            payment: payment,
                            isDark: isDark,
                            onTap: () {
                              final draft = PaymentDraft(
                                iban: payment.reference,
                                recipientName: payment.name,
                                addressLine1: 'Hardstrasse',
                                addressLine2: '6',
                                postCode: '8105',
                                city: 'Zürich',
                                country: 'Switzerland',
                                recipientReference: '100.112.90000.99',
                                purposeOfPayment:
                                    'Monthly Appartment rent costs',
                              );
                              context.push(
                                '/payments/payment-progress-step-1',
                                extra: draft,
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              const AppBottomNavigation(activeRoute: '/payments'),
            ],
          ),
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
    final backgroundColor = isDark
        ? AppColorSchemes.darkBackground
        : AppColorSchemes.lightBackground;
    final inactiveDividerColor =
        isDark ? AppColorSchemes.greysDarkGrey : AppColorSchemes.greysLightGrey;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Text(
                  'Payment',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              _HeaderIconButton(
                icon: Icons.close,
                color: textColor,
                onTap: () => context.go('/payments'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(color: AppColorSchemes.primaryDarkYellow),
                ),
                Expanded(
                  child: Container(color: inactiveDividerColor),
                ),
                Expanded(
                  child: Container(color: inactiveDividerColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.isDark,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColorSchemes.getTextColor(isDark);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF333333) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      height: 56,
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
        cursorColor: AppColorSchemes.primaryDarkYellow,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: 'IBAN, Name ...',
          hintStyle: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColorSchemes.greysMidGrey,
          ),
          prefixIcon: const Icon(
            M3Icons.search,
            color: AppColorSchemes.greysMidGrey,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    color: textColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionTitle({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColorSchemes.greysMidGrey,
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final _PaymentOption option;
  final bool isDark;
  final VoidCallback? onTap;

  const _PaymentOptionCard({
    required this.option,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColorSchemes.getCardBackgroundColor(isDark),
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option.title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColorSchemes.getTextColor(isDark),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColorSchemes.greysMidGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentPaymentTile extends StatelessWidget {
  final _RecentPayment payment;
  final bool isDark;
  final VoidCallback? onTap;

  const _RecentPaymentTile({
    required this.payment,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payment.name,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColorSchemes.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            payment.reference,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColorSchemes.greysMidGrey,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

class _PaymentOption {
  final String title;
  final String subtitle;
  const _PaymentOption({required this.title, required this.subtitle});
}

class _RecentPayment {
  final String name;
  final String amount;
  final String reference;
  final String secondaryAmount;

  const _RecentPayment({
    required this.name,
    required this.amount,
    required this.reference,
    required this.secondaryAmount,
  });
}

class _CarouselBullets extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final bool isDark;

  const _CarouselBullets({
    required this.currentIndex,
    required this.totalCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalCount,
        (index) {
          final isActive = index == currentIndex;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isActive ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColorSchemes.primaryDarkYellow
                      : AppColorSchemes.greysLightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              if (index < totalCount - 1) const SizedBox(width: 8),
            ],
          );
        },
      ),
    );
  }
}
