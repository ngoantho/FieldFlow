import 'package:field_flow/report/report_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/report/report_choose_parameter_page.dart';

import 'report_choose_parameter_page_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
void main() {
  late MockFirestoreHelper mockFirestoreHelper;

  setUp(() {
    mockFirestoreHelper = MockFirestoreHelper();
  });

  testWidgets('ReportChooseParameterPage finds date-users, then hit Print Report', (tester) async {
    when(mockFirestoreHelper.getUsers()).thenAnswer((_) async => {
      'user1': 'Q',
      'user2': 'Anthony',
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<FirestoreHelper>.value(value: mockFirestoreHelper),
        ],
        child: MaterialApp(home: ReportChooseParameterPage()),
      ),
    );
    await tester.pumpAndSettle();

    // Verify button exists
    expect(find.text("Print Report"), findsNWidgets(1));

    // Ensure Alice was selected
    expect(find.text('Q'), findsOneWidget);
    await tester.tap(find.text('Q')); // Select Alice
    await tester.tap(find.text('Anthony'));
    await tester.tap(find.text('Anthony')); // Reselect Alice

    expect(find.text("Select Date Range"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    expect(find.textContaining("Start Date"), findsOneWidget);
    final startDateFinder = find.text('3'); // Choose Day 3
    final endDateFinder = find.text('7'); // Choose Day 7
    expect(startDateFinder, findsWidgets);
    expect(endDateFinder, findsWidgets);

    await tester.tap(startDateFinder);
    await tester.pumpAndSettle();
    await tester.tap(endDateFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.tap(find.text('Print Report'));
    await tester.pumpAndSettle();
    

  });

  testWidgets('ReportChooseParameterPage print error when hitting Print Report without choosing date/users', (tester) async {
    when(mockFirestoreHelper.getUsers()).thenAnswer((_) async => {
      'user1': 'Q',
      'user2': 'Anthony',
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<FirestoreHelper>.value(value: mockFirestoreHelper),
        ],
        child: MaterialApp(home: ReportChooseParameterPage()),
      ),
    );
    await tester.pumpAndSettle();

    // Verify button exists
    expect(find.text("Print Report"), findsNWidgets(1));


    await tester.tap(find.text('Print Report'));
    await tester.pumpAndSettle();
    expect(find.text("Please select a date range and at least one user."), findsNWidgets(1));


  });
}
