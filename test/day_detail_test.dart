import 'package:field_flow/day_detail/day_detail.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

main() {
  group('Day Detail Page Tests', ()
  {
    testWidgets(
        'Day Detail Page Test show Check In Check Out time', (tester) async {


      final checkInTime = DateTime.now().subtract(Duration(days: 19, hours: 8));
      final checkOutTime = DateTime.now().subtract(Duration(days: 19));
      DayModel day = DayModel(
          CheckEntryModel(checkInTime,
              checkOutTime),
          [
            LocationModel(47.6205, -122.3493, Duration(hours: 3)),
            LocationModel(47.6097, -122.3410, Duration(hours: 3)),
            LocationModel(47.6094, -122.3180, Duration(hours: 2))
          ]);

      // Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DayDetail(dayModel: day)),
        ),
      );

      // Check for main text components

      expect(find.textContaining("Check-in at: $checkInTime \n"), findsOneWidget);
      expect(find.textContaining('Check-out at: $checkOutTime\n\n\n'), findsOneWidget);

      final viewMapButton = find.widgetWithText(ElevatedButton, "View Path Map");
      expect(viewMapButton, findsOneWidget);
      await tester.tap(viewMapButton);
      await tester.pumpAndSettle();

      expect(find.byType(GoogleMap), findsOneWidget);

    });
  });
}