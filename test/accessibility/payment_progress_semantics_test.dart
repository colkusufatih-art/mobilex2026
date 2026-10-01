import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilex2025/features/payments/domain/payment_draft.dart';
import 'package:mobilex2025/features/payments/presentation/payment_progress_step3_screen.dart';

void main() {
  testWidgets('Next button exposes accessible semantics', (tester) async {
    final semanticsHandle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentProgressStep3Screen(
              draft: PaymentDraft(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      final semanticsNode = tester.getSemantics(buttonFinder);
      final semanticsData = semanticsNode.getSemanticsData();
      expect(semanticsData.hasAction(SemanticsAction.tap), isTrue);
      expect(semanticsData.label.contains('Next'), isTrue);
    } finally {
      semanticsHandle.dispose();
    }
  });
}
