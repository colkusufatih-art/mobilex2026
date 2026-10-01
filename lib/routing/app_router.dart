import 'package:go_router/go_router.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/sign_up/presentation/sign_up_screen.dart';
import '../features/login/presentation/login_existing_user_screen.dart';
import '../features/pin/presentation/pin_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/assets_graph_screen.dart';
import '../features/assets/presentation/assets_screen.dart';
import '../features/assets/presentation/portfolio_detail_screen.dart';
import '../features/assets/presentation/portfolio_details_screen.dart';
import '../features/assets/presentation/position_detail_screen.dart';
import '../features/assets/presentation/performance_detail_screen.dart';
import '../features/assets/presentation/pension_detail_screen.dart';
import '../features/assets/presentation/pension_details_screen.dart';
import '../features/assets/presentation/pension_transaction_detail_screen.dart';
import '../features/assets/presentation/mortgage_detail_screen.dart';
import '../features/account_transactions/presentation/account_transactions_screen.dart';
import '../features/account_transactions/presentation/account_transactions_search_screen.dart';
import '../features/account_preview/presentation/account_preview_screen.dart';
import '../features/article/presentation/article_screen.dart';
import '../features/article_loans/presentation/article_loans_screen.dart';
import '../features/article_brokerage/presentation/article_brokerage_screen.dart';
import '../features/cards_benefits/presentation/cards_benefits_screen.dart';
import '../features/credit_card_benefits/presentation/credit_card_benefits_screen.dart';
import '../features/bonuspass_benefits/presentation/bonuspass_benefits_screen.dart';
import '../features/more/presentation/more_screen.dart';
import '../features/documents/presentation/documents_screen.dart';
import '../features/contact_support/presentation/contact_support_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/edit_address_screen.dart';
import '../features/messages/presentation/messages_screen.dart';
import '../features/messages/presentation/new_message_screen.dart';
import '../features/messages/presentation/message_confirmed_screen.dart';
import '../features/messages/presentation/message_detail_screen.dart';
import '../features/trading/presentation/trading_screen.dart';
import '../features/trading/presentation/trading_search_screen.dart';
import '../features/trading/presentation/buy_screen.dart';
import '../features/trading/presentation/sell_screen.dart';
import '../features/trading/presentation/sell_position_detail_screen.dart';
import '../features/trading/presentation/sell_confirm_screen.dart';
import '../features/trading/presentation/sell_confirmed_screen.dart';
import '../features/trading/presentation/pending_order_detail_screen.dart';
import '../features/trading/presentation/buy_position_detail_screen.dart';
import '../features/trading/presentation/buy_confirm_screen.dart';
import '../features/trading/presentation/buy_confirmed_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/device_properties/presentation/device_properties_screen.dart';
import '../features/account_detail/presentation/account_detail_screen.dart';
import '../features/login_settings/presentation/login_settings_screen.dart';
import '../features/transaction_detail/presentation/transaction_detail_screen.dart';
import '../features/payments/presentation/payments_screen.dart';
import '../features/payments/presentation/payments_search_screen.dart';
import '../features/payments/presentation/open_payment_detail_screen.dart';
import '../features/payments/presentation/standing_order_detail_screen.dart';
import '../features/payments/presentation/archived_payment_detail_screen.dart';
import '../features/payments/presentation/new_payment_screen.dart';
import '../features/payments/presentation/payment_progress_step1_screen.dart';
import '../features/payments/presentation/payment_progress_step2_screen.dart';
import '../features/payments/presentation/payment_progress_step3_screen.dart';
import '../features/payments/presentation/confirm_payment_screen.dart';
import '../features/payments/presentation/payment_confirmed_screen.dart';
import '../features/payments/domain/payment_draft.dart';
import '../features/payments/presentation/account_transfer_screen.dart';
import '../features/payments/presentation/confirm_account_transfer_screen.dart';
import '../features/payments/presentation/account_transfer_confirmed_screen.dart';
import '../features/payments/domain/account_transfer_draft.dart';
import '../features/payments/presentation/foreign_payment_step1_screen.dart';
import '../features/payments/presentation/foreign_payment_step2_screen.dart';
import '../features/payments/presentation/qr_payment_step1_screen.dart';
import '../features/payments/presentation/qr_scan_screen.dart';
import '../features/qr_bill/presentation/qr_bill_screen.dart';

/// App Router Configuration
///
/// Defines all routes based on Figma frame names
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign_up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/login-existing-user',
      name: 'login_existing_user',
      builder: (context, state) => const LoginExistingUserScreen(),
    ),
    GoRoute(
      path: '/pin',
      name: 'pin',
      builder: (context, state) => const PinScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/assets-graph',
      name: 'assets_graph',
      builder: (context, state) => const AssetsGraphScreen(),
    ),
    GoRoute(
      path: '/assets',
      name: 'assets',
      builder: (context, state) => const AssetsScreen(),
    ),
    GoRoute(
      path: '/portfolio-detail',
      name: 'portfolio_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PortfolioDetailScreen(
          title: extra?['title'] ?? '1501 CHF',
          amount: extra?['amount'] ?? 'CHF 10\'193.00',
        );
      },
    ),
    GoRoute(
      path: '/portfolio-details',
      name: 'portfolio_details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PortfolioDetailsScreen(
          title: extra?['title'] ?? '1501 CHF',
          amount: extra?['amount'] ?? 'CHF 10\'193.00',
        );
      },
    ),
    GoRoute(
      path: '/position-detail',
      name: 'position_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PositionDetailScreen(
          title: extra?['title'] ?? '3 % Kanton Zürich 2004 – 31.07.2026 (1737171)',
          amount: extra?['amount'] ?? 'CHF 98.32',
          quantity: extra?['quantity'],
          percentage: extra?['percentage'],
          isPositive: extra?['isPositive'],
        );
      },
    ),
    GoRoute(
      path: '/performance-detail',
      name: 'performance_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PerformanceDetailScreen(
          title: extra?['title'] ?? '2025',
          subtitle: extra?['subtitle'] ?? 'Jan. - 31. August 2025',
          amount: extra?['amount'] ?? 'CHF 344\'193.00',
          percentage: extra?['percentage'] ?? '+4.66%',
          change: extra?['change'] ?? 'CHF +13\'163.80',
          isPositive: extra?['isPositive'] ?? true,
        );
      },
    ),
    GoRoute(
      path: '/pension-detail',
      name: 'pension_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PensionDetailScreen(
          title: extra?['title'] ?? 'Pillar 3a',
          amount: extra?['amount'] ?? 'CHF 44\'323.00',
        );
      },
    ),
    GoRoute(
      path: '/pension-details',
      name: 'pension_details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PensionDetailsScreen(
          title: extra?['title'] ?? 'Pillar 3a',
          amount: extra?['amount'] ?? 'CHF 44\'323.00',
        );
      },
    ),
    GoRoute(
      path: '/pension-transaction-detail',
      name: 'pension_transaction_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PensionTransactionDetailScreen(
          title: extra?['title'] ?? 'Payment 152',
          date: extra?['date'] ?? '29. June',
          amount: extra?['amount'] ?? 'CHF 150.00',
        );
      },
    ),
    GoRoute(
      path: '/mortgage-detail',
      name: 'mortgage_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MortgageDetailScreen(
          title: extra?['title'] ?? 'Seestrasse 1, Zürich',
          amount: extra?['amount'] ?? 'CHF 800\'000.00',
        );
      },
    ),
    GoRoute(
      path: '/account-transactions',
      name: 'account_transactions',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AccountTransactionsScreen(
          accountName: extra?['accountName'] ?? 'Private Account',
          accountBalance: extra?['accountBalance'] ?? 'CHF 4\'323.30',
          accountType: extra?['accountType'] ?? 'Private',
        );
      },
    ),
    GoRoute(
      path: '/account-transactions/search',
      name: 'account_transactions_search',
      builder: (context, state) => const AccountTransactionsSearchScreen(),
    ),
    GoRoute(
      path: '/account-preview',
      name: 'account_preview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AccountPreviewScreen(
          accountName: extra?['accountName'] ?? 'Private Account',
          accountBalance: extra?['accountBalance'] ?? 'CHF 4\'323.30',
          accountType: extra?['accountType'] ?? 'Private',
        );
      },
    ),
    GoRoute(
      path: '/article',
      name: 'article',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ArticleScreen(
          title: extra?['title'] ?? 'Article Title',
          subtitle: extra?['subtitle'] ?? 'Article Subtitle',
        );
      },
    ),
    GoRoute(
      path: '/article-loans',
      name: 'article_loans',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ArticleLoansScreen(
          title: extra?['title'] ?? 'Benefit from our low-cost loans',
          subtitle: extra?['subtitle'] ?? 'Start your invest with Crealogix!',
        );
      },
    ),
    GoRoute(
      path: '/article-brokerage',
      name: 'article_brokerage',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ArticleBrokerageScreen(
          title: extra?['title'] ?? 'Start Brokarage with Crealogix',
          subtitle: extra?['subtitle'] ?? 'Start your invest with Crealogix!',
        );
      },
    ),
    GoRoute(
      path: '/payments',
      name: 'payments',
      builder: (context, state) {
        PaymentDraft? draft;
        AccountTransferDraft? accountTransferDraft;
        int? selectedTab;
        
        if (state.extra is PaymentDraft) {
          draft = state.extra as PaymentDraft;
        } else if (state.extra is AccountTransferDraft) {
          accountTransferDraft = state.extra as AccountTransferDraft;
        } else if (state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          selectedTab = extra['selectedTab'] as int?;
        }
        
        return PaymentsScreen(
          newPayment: draft,
          newAccountTransfer: accountTransferDraft,
          selectedTab: selectedTab,
        );
      },
    ),
    GoRoute(
      path: '/payments/search',
      name: 'payments_search',
      builder: (context, state) => const PaymentsSearchScreen(),
    ),
    GoRoute(
      path: '/payments/new-payment',
      name: 'payments_new_payment',
      builder: (context, state) => const NewPaymentScreen(),
    ),
    GoRoute(
      path: '/payments/payment-progress-step-1',
      name: 'payments_payment_progress_step_1',
      builder: (context, state) {
        final draft = state.extra is PaymentDraft
            ? state.extra as PaymentDraft
            : PaymentDraft();
        return PaymentProgressStep1Screen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/foreign-payment-step-1',
      name: 'foreign_payment_step_1',
      builder: (context, state) {
        final draft = state.extra is PaymentDraft
            ? state.extra as PaymentDraft
            : PaymentDraft();
        return ForeignPaymentStep1Screen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/qr-payment-step-1',
      name: 'qr_payment_step_1',
      builder: (context, state) {
        final draft = state.extra is PaymentDraft
            ? state.extra as PaymentDraft
            : PaymentDraft();
        return QrPaymentStep1Screen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/qr-scan',
      name: 'qr_scan',
      builder: (context, state) => const QrScanScreen(),
    ),
    GoRoute(
      path: '/payments/foreign-payment-step-2',
      name: 'foreign_payment_step_2',
      builder: (context, state) {
        final draft = state.extra is PaymentDraft
            ? state.extra as PaymentDraft
            : PaymentDraft();
        return ForeignPaymentStep2Screen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/payment-progress-step-2',
      name: 'payments_payment_progress_step_2',
      builder: (context, state) {
        final draft = state.extra is PaymentDraft
            ? state.extra as PaymentDraft
            : PaymentDraft();
        return PaymentProgressStep2Screen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/payment-progress-step-3',
      name: 'payments_payment_progress_step_3',
      builder: (context, state) {
        final draft = state.extra is PaymentDraft
            ? state.extra as PaymentDraft
            : PaymentDraft();
        return PaymentProgressStep3Screen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/payment-confirmed',
      name: 'payments_payment_confirmed',
      builder: (context, state) {
        final draft = state.extra as PaymentDraft?;
        if (draft == null) {
          return const PaymentsScreen();
        }
        return PaymentConfirmedScreen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/confirm-payment',
      name: 'payments_confirm_payment',
      builder: (context, state) {
        final draft = state.extra as PaymentDraft?;
        if (draft == null) {
          return const PaymentsScreen();
        }
        return ConfirmPaymentScreen(draft: draft);
      },
    ),
    GoRoute(
      path: '/open-payment-detail',
      name: 'open_payment_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OpenPaymentDetailScreen(
          recipient: extra?['recipient'] ?? 'Recipient',
          amount: extra?['amount'] ?? 'CHF 0.00',
          subtitle: extra?['subtitle'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/standing-order-detail',
      name: 'standing_order_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return StandingOrderDetailScreen(
          recipient: extra?['recipient'] ?? 'Recipient',
          amount: extra?['amount'] ?? 'CHF 0.00',
          subtitle: extra?['subtitle'] ?? '',
          returnRoute: extra?['returnRoute'] as String?,
          returnRouteExtra: extra?['returnRouteExtra'] as Map<String, dynamic>?,
        );
      },
    ),
    GoRoute(
      path: '/archived-payment-detail',
      name: 'archived_payment_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ArchivedPaymentDetailScreen(
          recipient: extra?['recipient'] ?? 'Recipient',
          amount: extra?['amount'] ?? 'CHF 0.00',
          subtitle: extra?['subtitle'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/cards-benefits',
      name: 'cards_benefits',
      builder: (context, state) => const CardsBenefitsScreen(),
    ),
    GoRoute(
      path: '/credit-card-benefits',
      name: 'credit_card_benefits',
      builder: (context, state) => const CreditCardBenefitsScreen(),
    ),
    GoRoute(
      path: '/bonuspass-benefits',
      name: 'bonuspass_benefits',
      builder: (context, state) => const BonusPassBenefitsScreen(),
    ),
    GoRoute(
      path: '/more',
      name: 'more',
      builder: (context, state) => const MoreScreen(),
    ),
    GoRoute(
      path: '/documents',
      name: 'documents',
      builder: (context, state) => const DocumentsScreen(),
    ),
    GoRoute(
      path: '/contact-support',
      name: 'contact_support',
      builder: (context, state) => const ContactSupportScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit-address',
      name: 'edit_address',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return EditAddressScreen(
          initialStreet: extra?['initialStreet'] ?? 'Maneggstrasse 17',
          initialPostcode: extra?['initialPostcode'] ?? '8105',
          initialCity: extra?['initialCity'] ?? 'Zürich',
          initialCountry: extra?['initialCountry'] ?? 'Switzerland',
          onSave: (street, addressLine2, postcode, city, country) {
            // onSave is handled in EditAddressScreen._handleSave
          },
        );
      },
    ),
    GoRoute(
      path: '/messages',
      name: 'messages',
      builder: (context, state) => const MessagesScreen(),
    ),
    GoRoute(
      path: '/messages/new',
      name: 'new_message',
      builder: (context, state) => const NewMessageScreen(),
    ),
    GoRoute(
      path: '/messages/detail',
      name: 'message_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MessageDetailScreen(
          subject: extra?['subject'] ?? '',
          message: extra?['message'] ?? '',
          sender: extra?['sender'] ?? '',
          dateTime: extra?['dateTime'] ?? '',
          hasAttachment: extra?['hasAttachment'] ?? false,
          onDelete: extra?['onDelete'] as Function()?,
        );
      },
    ),
    GoRoute(
      path: '/messages/confirmed',
      name: 'message_confirmed',
      builder: (context, state) => const MessageConfirmedScreen(),
    ),
    GoRoute(
      path: '/trading',
      name: 'trading',
      builder: (context, state) => const TradingScreen(),
    ),
    GoRoute(
      path: '/trading/search',
      name: 'trading_search',
      builder: (context, state) => const TradingSearchScreen(),
    ),
    GoRoute(
      path: '/trading/buy',
      name: 'buy',
      builder: (context, state) => const BuyScreen(),
    ),
    GoRoute(
      path: '/trading/sell',
      name: 'sell',
      builder: (context, state) => const SellScreen(),
    ),
    GoRoute(
      path: '/trading/sell-position-detail',
      name: 'sell_position_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SellPositionDetailScreen(
          title: extra?['title'] ?? '3 % Kanton Zürich 2004 – 31.07.2026 (1737171)',
          amount: extra?['amount'] ?? 'CHF 1\'758.32',
          subtitle: extra?['subtitle'],
          percentage: extra?['percentage'],
          isPositive: extra?['isPositive'],
        );
      },
    ),
    GoRoute(
      path: '/trading/buy-position-detail',
      name: 'buy_position_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BuyPositionDetailScreen(
          title: extra?['title'] ?? '',
          amount: extra?['amount'] ?? '',
          subtitle: extra?['subtitle'],
        );
      },
    ),
    GoRoute(
      path: '/trading/buy-confirm',
      name: 'buy_confirm',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BuyConfirmScreen(
          title: extra?['title'] ?? '',
          subtitle: extra?['subtitle'] ?? '',
          amount: extra?['amount'] ?? '',
          pcs: extra?['pcs'] ?? '1',
          portfolio: extra?['portfolio'] ?? '',
          stockExchange: extra?['stockExchange'] ?? '',
          orderType: extra?['orderType'] ?? 'Best',
          validUntil: extra?['validUntil'] ?? DateTime.now(),
          debitAccount: extra?['debitAccount'] ?? '',
          limitChf: extra?['limitChf'],
        );
      },
    ),
    GoRoute(
      path: '/trading/buy-confirmed',
      name: 'buy_confirmed',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BuyConfirmedScreen(
          title: extra?['title'] ?? '',
          amount: extra?['amount'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/trading/sell-confirm',
      name: 'sell_confirm',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SellConfirmScreen(
          title: extra?['title'] ?? '3 % Kanton Zürich 2004 – 31.07.2026 (1737171)',
          subtitle: extra?['subtitle'] ?? 'NESN-T2 | Valor 993886335 ISIN CH9938863350',
          amount: extra?['amount'] ?? 'CHF 57.00',
          pcs: extra?['pcs'] ?? '1',
          stockExchange: extra?['stockExchange'] ?? 'SIX SWISS EXCHANGE / EUROPE / CHF',
          orderType: extra?['orderType'] ?? 'Best',
          validUntil: extra?['validUntil'] as DateTime? ?? DateTime(2025, 12, 31),
          settlementAccount: extra?['settlementAccount'] ?? 'Reto Haldner\n1518 EUR\nCH85 9558 4848 4932 3332 2\nCHF 4\'323.30',
          limitChf: extra?['limitChf'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/trading/sell-confirmed',
      name: 'sell_confirmed',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SellConfirmedScreen(
          title: extra?['title'] ?? 'Order',
          amount: extra?['amount'] ?? 'CHF 57.00',
        );
      },
    ),
    GoRoute(
      path: '/trading/pending-order-detail',
      name: 'pending_order_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PendingOrderDetailScreen(
          title: extra?['title'] ?? 'Akt. 3M USD 0.01 (998421819)',
          amount: extra?['amount'] ?? '99.00%',
          subtitle: extra?['subtitle'],
          orderType: extra?['orderType'],
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/device-properties',
      name: 'device_properties',
      builder: (context, state) => const DevicePropertiesScreen(),
    ),
    GoRoute(
      path: '/account-detail',
      name: 'account_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AccountDetailScreen(
            accountTitle: extra?['accountTitle'] ?? 'Private Account');
      },
    ),
    GoRoute(
      path: '/login-settings',
      name: 'login_settings',
      builder: (context, state) => const LoginSettingsScreen(),
    ),
    GoRoute(
      path: '/transaction-detail',
      name: 'transaction_detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TransactionDetailScreen(
          title: extra?['title'] ?? 'Amazon Germany',
          subtitle: extra?['subtitle'] ?? '',
          amount: extra?['amount'] ?? '',
          originalAmount: extra?['originalAmount'],
        );
      },
    ),
    GoRoute(
      path: '/qr-bill',
      name: 'qr_bill',
      builder: (context, state) => const QrBillScreen(),
    ),
    GoRoute(
      path: '/payments/account-transfer',
      name: 'account_transfer',
      builder: (context, state) {
        final draft = state.extra is AccountTransferDraft
            ? state.extra as AccountTransferDraft
            : null;
        return AccountTransferScreen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/confirm-account-transfer',
      name: 'confirm_account_transfer',
      builder: (context, state) {
        final draft = state.extra as AccountTransferDraft?;
        if (draft == null) {
          return const AccountTransferScreen();
        }
        return ConfirmAccountTransferScreen(draft: draft);
      },
    ),
    GoRoute(
      path: '/payments/account-transfer-confirmed',
      name: 'account_transfer_confirmed',
      builder: (context, state) {
        final draft = state.extra as AccountTransferDraft?;
        if (draft == null) {
          return const AccountTransferScreen();
        }
        return AccountTransferConfirmedScreen(draft: draft);
      },
    ),
  ],
);
