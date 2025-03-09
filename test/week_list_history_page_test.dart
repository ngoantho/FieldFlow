import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/week_list/choose_worker_page.dart';
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

  testWidgets('WeekListHistoryPage displays ChooseWorkerPage for Manager',
          (tester) async {
        const testUserId = 'managerUserId';
        const testUserRole = 'Manager';

        // Mock FirestoreHelper to return fake users
        when(mockFirestoreHelper.fetchUsers()).thenAnswer((_) async => [
          {'id': 'worker_1', 'name': 'Test Worker'},
          {'id': 'worker_2', 'name': 'Another Worker'},
        ]);

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

        // Expect to see "Week Report" title in the AppBar
        expect(find.text('Week Report'), findsOneWidget);

        // Ensure "Choose Worker" page is displayed
        expect(find.byType(ChooseWorkerPage), findsOneWidget);

        // Ensure mock users appear in the list
        expect(find.text('Test Worker'), findsOneWidget);
        expect(find.text('Another Worker'), findsOneWidget);

        // Ensure "Make Report" button exists
        expect(find.text("Make Report"), findsOneWidget);
      });
}
