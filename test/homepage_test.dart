import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/homepage.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/providers/position_provider.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'homepage_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
void main() {
  testWidgets('Homepage shows check in/out button', (tester) async {
    final firestoreHelper = MockFirestoreHelper();
    final timeTracker = TimeTracker(firestoreHelper: firestoreHelper);
    final positionProvider = PositionProvider();

    // Create a check entry
    CheckEntryModel checkEntry = CheckEntryModel(DateTime.now(), DateTime.now());

    // Create a single location model
    LocationModel location =
    LocationModel(47.6062, -122.3321, Duration(hours: 8));

    // Create a day model with one location
    DayModel day = DayModel(checkEntry, [location]);

    // Create a week model with the single day
    WeekModel mockWeek = WeekModel([day]);

    when(firestoreHelper.getWeeksStream(
        userId: DateTime.now().weekday.toString()))
        .thenAnswer((_) => Stream.value([mockWeek]));

    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider<TimeTracker>.value(value: timeTracker),
      ChangeNotifierProvider<PositionProvider>.value(value: positionProvider),
      Provider<FirestoreHelper>.value(value: firestoreHelper),

    ], child: MaterialApp(home: Homepage())));

    expect(find.text('Check In'), findsOne);

    await tester.tap(find.text('Check In'));
    await tester.pumpAndSettle();
    expect(find.text('Week Report'), findsOneWidget);
    await tester.tap(find.textContaining('Week Report'));
    //expect(find.text("Manager"), findsOneWidget);

    //expect(find.textContaining('Checked In on'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    //expect(find.text('Check Out'), findsOne);
  });
}
