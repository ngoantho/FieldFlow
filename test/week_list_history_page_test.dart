import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:field_flow/week_list/week_list_history_page.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'week_list_history_page_test.mocks.dart';

// Generate a mock FirestoreHelper
@GenerateMocks([FirestoreHelper])
void main() {
  const testUserId = 'testUserId';
  const testUserRole = 'Field Worker';
  late MockFirestoreHelper mockFirestoreHelper;

  mockFirestoreHelper = MockFirestoreHelper();

  // Create a check entry
  CheckEntryModel checkEntry = CheckEntryModel(DateTime.now(), DateTime.now());

  // Create a single location model
  LocationModel location =
      LocationModel(47.6062, -122.3321, Duration(hours: 8));

  // Create a day model with one location
  DayModel day = DayModel(checkEntry, [location]);

  // Create a week model with the single day
  WeekModel mockWeek = WeekModel([day]);

  when(mockFirestoreHelper.getWeeksStream(
          userId: testUserId))
      .thenAnswer((_) => Stream.value([mockWeek]));

  testWidgets('WeekListHistory Page Test (Field Worker) shows WeekList',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<FirestoreHelper>.value(value: mockFirestoreHelper),
        ],
        child: MaterialApp(
          home: WeekListHistoryPage(
            userId: testUserId,
            userRole: testUserRole,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for UI to fully render
    expect(find.text('Week Report'), findsOneWidget);
    expect(find.byType(WeekList), findsOneWidget);
  });
}
