import 'package:field_flow/day_list/day_list.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Day List tests', () {
    testWidgets('Day list for current week', (tester) async {
      final weekModel = WeekModel([
        DayModel(
            CheckEntryModel(
                DateTime(2025, 2, 17, 9), DateTime(2025, 2, 17, 17)),
            []),
        DayModel(
            CheckEntryModel(
                DateTime(2025, 2, 21, 9), DateTime(2025, 2, 21, 17)),
            [])
      ]);
      await tester.pumpWidget(MaterialApp(
          home: DayList(
        weekModel: weekModel,
      )));

      expect(find.textContaining('Monday - 02/17/2025'), findsOneWidget);
      expect(find.textContaining('Friday - 02/21/2025'), findsOneWidget);
    });
  });
}
