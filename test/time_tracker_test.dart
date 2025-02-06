
import 'package:field_flow/providers/time_tracker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main(){
  group('Time Tracker Tests', (){
    testWidgets('Test Check In record the moment 8 hours ago from now', (tester) async{
      final timeTracker = TimeTracker();

      timeTracker.checkIn();

      final expectedResult = DateTime.now().subtract(Duration(hours: 8));

      expect(timeTracker.checkInTime, isNotNull);
      expect(timeTracker.checkInTime!.difference(expectedResult).inSeconds, lessThanOrEqualTo(Duration(seconds: 1).inSeconds));
    });

    testWidgets('Test Check Out record this moment and process a list of Location', (tester) async{
      final timeTracker = TimeTracker();

      timeTracker.checkIn();
      final checkInTime = timeTracker.checkInTime;
      List<(Position, DateTime)> mockData = [
        (Position(
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
        DateTime.now().subtract(Duration(minutes: 30))),
        (Position(
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
        DateTime.now().subtract(Duration(minutes: 20))),
        (Position(
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
        DateTime.now().subtract(Duration(minutes: 10))),
      ];

      timeTracker.checkOut(mockData);

      final expectedResult = DateTime.now();

      expect(timeTracker.lastCheckOutTime!.difference(expectedResult).inSeconds, lessThanOrEqualTo(Duration(seconds: 1).inSeconds));

      for (int i = 0; i < timeTracker.locationList.length; i++) {
        expect(timeTracker.locationList[i].latitude, mockData[i].$1.latitude);
        expect(timeTracker.locationList[i].longitude, mockData[i].$1.longitude);
      }
    });
  });
}