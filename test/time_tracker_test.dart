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
  });
}
