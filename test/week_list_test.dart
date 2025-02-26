import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'time_tracker_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
main() {
  group('Week List Page Tests', () {
    testWidgets('WeekList Page Test show 2 Week Entries', (tester) async {
      final firestoreHelper = MockFirestoreHelper();

      final timeTracker = TimeTracker(firestoreHelper: firestoreHelper);

      when(firestoreHelper.saveCheckIn(DateTime.now())).thenAnswer(
        (realInvocation) => Future.value('1'),
      );
      timeTracker.checkIn();

      // Create a check entry
      CheckEntryModel checkEntry = CheckEntryModel(checkInTime, checkOutTime);

      // Create a single location model
      LocationModel location = LocationModel(47.6062, -122.3321, Duration(hours: 8));

      // Create a day model with one location
      DayModel day = DayModel(checkEntry, [location]);

      // Create a week model with the single day
      WeekModel mockWeek = WeekModel([day]);

      when(firestoreHelper.saveCheckOut("1", DateTime.now(), []))
          .thenAnswer((realInvocation) => Future.value());
      timeTracker.checkOut(mockData);

      // Pump the widget
      await tester.pumpWidget(ChangeNotifierProvider<TimeTracker>.value(
        value: timeTracker,
        child: MaterialApp(
          home: WeekList(
            id: '1',
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.textContaining("Week Report: \n"), findsOneWidget);
    });
  });
}
