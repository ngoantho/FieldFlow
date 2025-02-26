import 'package:field_flow/providers/time_tracker.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

main() {
  group('Week List Page Tests', () {
    testWidgets('WeekList Page Test show 2 Week Entries', (tester) async {
      final timeTracker = TimeTracker(firestoreHelper: null);
      timeTracker.checkIn();

      List<(Position, DateTime)> mockData = [
        (
          Position(
            latitude: 47.6097,
            longitude: -122.3188,
            timestamp: DateTime.now().subtract(Duration(minutes: 30)),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          ),
          DateTime.now().subtract(Duration(minutes: 30))
        ),
        (
          Position(
            latitude: 47.6062,
            longitude: -122.3321,
            timestamp: DateTime.now().subtract(Duration(minutes: 20)),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          ),
          DateTime.now().subtract(Duration(minutes: 20))
        ),
        (
          Position(
            latitude: 47.6097,
            longitude: -122.3188, // Slight movement
            timestamp: DateTime.now().subtract(Duration(minutes: 10)),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          ),
          DateTime.now().subtract(Duration(minutes: 10))
        ),
      ];

      timeTracker.checkOut(mockData);
      // Pump the widget
      await tester.pumpWidget(ChangeNotifierProvider<TimeTracker>.value(
        value: timeTracker,
        child: MaterialApp(
          home: WeekList(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.textContaining("Week Report: \n"), findsOneWidget);
    });
  });
}
