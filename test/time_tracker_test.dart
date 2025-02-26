import 'package:field_flow/providers/time_tracker.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'time_tracker_test.mocks.dart';

// Generate mock for FirestoreHelper
@GenerateMocks([FirestoreHelper])
void main() {
  late TimeTracker timeTracker;
  late MockFirestoreHelper mockFirestoreHelper;

  setUp(() {
    mockFirestoreHelper = MockFirestoreHelper();
    timeTracker = TimeTracker(firestoreHelper: mockFirestoreHelper);
  });

  group('TimeTracker Tests', () {
    test('Check-in should save to Firestore and update state', () async {
      DateTime mockCheckInTime = DateTime(2025, 2, 25, 9, 0, 0);
      when(mockFirestoreHelper.saveCheckIn(any)).thenAnswer((_) async => 'mockEntryId');

      timeTracker.checkIn();

      await Future.delayed(Duration.zero);

      expect(timeTracker.checkedIn, true);
      expect(timeTracker.currentEntryId, 'mockEntryId');
      verify(mockFirestoreHelper.saveCheckIn(any)).called(1);
    });

    test('Check-out should save to Firestore and update state => checkedOut True and locationList is reset', () async {
      timeTracker.currentEntryId = 'mockEntryId';

      List<(Position, DateTime)> rawPositions = [
        (Position(latitude: 47.6062, longitude: -122.3321, timestamp: DateTime(2025, 2, 25, 10, 0, 0), accuracy: 5.0 , altitude: 50.0, altitudeAccuracy: 5.0, heading: 180.0, headingAccuracy: 2.0, speed: 1.5, speedAccuracy: 0.5), DateTime(2025, 2, 25, 10, 0, 0)),
      ];

      when(mockFirestoreHelper.saveCheckOut(any, any, any)).thenAnswer((_) async {});

      timeTracker.checkOut(rawPositions);

      await Future.delayed(Duration.zero);

      expect(timeTracker.checkedOut, true);
      expect(timeTracker.locationList.isNotEmpty, false);
      verify(mockFirestoreHelper.saveCheckOut('mockEntryId', any, any)).called(1);
    });

    test('Check-out should do nothing if no check-in ID exists', () async {
      List<(Position, DateTime)> rawPositions = [
        (Position(latitude: 47.6062, longitude: -122.3321, timestamp: DateTime(2025, 2, 25, 10, 0, 0), accuracy: 5.0 , altitude: 50.0, altitudeAccuracy: 5.0, heading: 180.0, headingAccuracy: 2.0, speed: 1.5, speedAccuracy: 0.5), DateTime(2025, 2, 25, 10, 0, 0)),
      ];

      timeTracker.currentEntryId = null;

      timeTracker.checkOut(rawPositions);

      await Future.delayed(Duration.zero);

      expect(timeTracker.checkedOut, false);
      verifyNever(mockFirestoreHelper.saveCheckOut(any, any, any));
    });

    test('processRawPosition should segment locations when distance > 5 meters', () {
      // Mock position data
      List<(Position, DateTime)> mockPositions = [
        (Position(
          latitude: 47.6062,
          longitude: -122.3321,
          timestamp: DateTime(2025, 2, 25, 10, 0, 0),
          accuracy: 5.0,
          altitude: 50.0,
          altitudeAccuracy: 5.0,
          heading: 180.0,
          headingAccuracy: 2.0,
          speed: 1.5,
          speedAccuracy: 0.5,
        ), DateTime(2025, 2, 25, 10, 0, 0)),

        // Second point close to the first (within 5m, should be merged)
        (Position(
          latitude: 47.6063,
          longitude: -122.3322,
          timestamp: DateTime(2025, 2, 25, 10, 5, 0),
          accuracy: 5.0,
          altitude: 50.0,
          altitudeAccuracy: 5.0,
          heading: 180.0,
          headingAccuracy: 2.0,
          speed: 1.5,
          speedAccuracy: 0.5,
        ), DateTime(2025, 2, 25, 10, 5, 0)),

        // Third point farther than 5m (should start a new segment)
        (Position(
          latitude: 47.6070,
          longitude: -122.3350,
          timestamp: DateTime(2025, 2, 25, 10, 15, 0),
          accuracy: 5.0,
          altitude: 50.0,
          altitudeAccuracy: 5.0,
          heading: 180.0,
          headingAccuracy: 2.0,
          speed: 1.5,
          speedAccuracy: 0.5,
        ), DateTime(2025, 2, 25, 10, 15, 0)),
      ];

      timeTracker.checkOutTime = DateTime(2025, 2, 25, 17, 0, 0);
      List<LocationModel> result = timeTracker.processRawPosition(mockPositions);

      // Assertions
      expect(result.length, 3); // Two segments should be created
      expect(result[0].latitude, 47.6062); // First segment should be from the first position
      expect(result[1].latitude, 47.6063); // Second segment should be from the last position
    });
  });
}
