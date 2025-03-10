import 'package:field_flow/day_list/day_list_history_page.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'time_tracker_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
main() {
  group('Week List Page Tests', () {
    testWidgets('WeekList Page Test show 2 Week Entries', (tester) async {
      final firestoreHelper = MockFirestoreHelper();

      // Create a check entry
      CheckEntryModel checkEntry =
          CheckEntryModel(DateTime.now(), DateTime.now());

      // Create a single location model
      LocationModel location =
          LocationModel(47.6062, -122.3321, Duration(hours: 8));

      // Create a day model with one location
      DayModel day = DayModel(checkEntry, [location]);

      // Create a week model with the single day
      WeekModel mockWeek = WeekModel([day]);

      when(firestoreHelper.getWeeksStream(userId: '1'))
          .thenAnswer((_) => Stream.value([mockWeek]));

      // Pump the widget
      await tester.pumpWidget(Provider<FirestoreHelper>.value(
        value: firestoreHelper,
        child: MaterialApp(
          home: WeekList(
            id: '1',
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.textContaining("Week Report: \n"), findsOneWidget);

      final week1Btn = find.byType(ElevatedButton);
      expect(week1Btn, findsOneWidget);

      await tester.tap(week1Btn);
      await tester.pumpAndSettle();

      expect(find.byType(DayListHistoryPage), findsOneWidget);
    });
  });
}
