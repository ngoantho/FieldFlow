import 'package:field_flow/day_detail/day_detail_page.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'week_list_history_page_test.mocks.dart';

void main() {
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
      userId: DateTime.now().weekday.toString()))
      .thenAnswer((_) => Stream.value([mockWeek]));

  testWidgets('DayDetailPage Test populate DayDetail',
          (tester) async {
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: DayDetailPage(dayModel: day)),
              ),
            );

        await tester.pumpAndSettle(); // Wait for UI to fully render

        // Expect to find BOTH Worker & Manager Tab
            expect(find.textContaining("Check-in at: ${checkEntry.checkInTime} \n"), findsOneWidget);
      });
}
