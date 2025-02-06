import 'package:field_flow/providers/time_tracker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([TimeTracker])
void main() {
  group('Time Tracker Tests', () {
    test('Check in, wait 5 seconds, check out', () async {
      final timeTracker = TimeTracker();

      timeTracker.checkIn();
      expect(timeTracker.checkInTime, isNotNull);

      await Future.delayed(Duration(seconds: 5));
      final expectedResult = DateTime.now();
      timeTracker.checkOut([]);

      expect(timeTracker.checkOutTime, isNotNull);
      expect(timeTracker.checkOutTime, equals(expectedResult));
    });

    test('Test Check Out record this moment and process a list of Location',
        () async {
      final timeTracker = TimeTracker();
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

      final expectedResult = DateTime.now();

      expect(timeTracker.lastCheckOutTime!.difference(expectedResult).inSeconds,
          lessThanOrEqualTo(Duration(seconds: 1).inSeconds));

      for (int i = 0; i < timeTracker.locationList.length; i++) {
        expect(timeTracker.locationList[i].latitude, mockData[i].$1.latitude);
        expect(timeTracker.locationList[i].longitude, mockData[i].$1.longitude);
      }
    });
  });
}
