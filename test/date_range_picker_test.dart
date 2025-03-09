import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:field_flow/report/date_range_picker.dart';

void main() {
  testWidgets('DateRangePickerWidget displays and selects a date range', (WidgetTester tester) async {
    DateTime? startDate;
    DateTime? endDate;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DateRangePickerWidget(
          startDate: startDate,
          endDate: endDate,
          onDateRangeSelected: (start, end) {
            startDate = start;
            endDate = end;
          },
        ),
      ),
    ));

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
    await tester.pump();
    expect(startDate, isNotNull);
    expect(endDate, isNotNull);

  });
}
