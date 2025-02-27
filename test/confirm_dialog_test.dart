import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestClass extends StatefulWidget {
  const _TestClass();

  @override
  State<_TestClass> createState() => _TestClassState();
}

class _TestClassState extends State<_TestClass> with DialogConfirmMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showConfirmDialog(context: context, title: 'something');
        },
        child: Text('show dialog'));
  }
}

void main() {
  group('Confirm Dialog tests', () {
    testWidgets('dialog shows Cancel/Confirm', (tester) async {
      await tester.pumpWidget(MaterialApp(home: _TestClass()));

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('Confirm button navigates back with true', (tester) async {
      await tester.pumpWidget(MaterialApp(home: _TestClass()));

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final confirmButton = find.text('Confirm');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
    });
  });
}
