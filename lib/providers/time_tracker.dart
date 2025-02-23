// import 'package:field_flow/model/check_entry_model.dart';
// import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
// import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:field_flow/db/firestore_helper.dart';

class TimeTracker with ChangeNotifier {
  DateTime? checkInTime;
  DateTime? checkOutTime;
  DateTime? lastCheckOutTime;
  // List<WeekModel> weekList = [];
  // WeekModel? currentWeek;
  List<LocationModel> locationList = [];
  bool checkedIn = false;
  bool checkedOut = false;

  final FirestoreHelper _firestoreHelper;
  String? currentEntryId; // Firestore ID of current entry

  TimeTracker({required FirestoreHelper firestoreHelper}) : _firestoreHelper = firestoreHelper;

  void checkIn() async {
    checkInTime = DateTime.now();
    checkedIn = true;
    currentEntryId = await _firestoreHelper.saveCheckIn(checkInTime!);
    notifyListeners();
  }

  void checkOut(List<(Position, DateTime)> rawPositions) async {

    if (currentEntryId == null) return;

    checkedOut = true;
    checkOutTime = DateTime.now();
    lastCheckOutTime = checkOutTime;

    locationList = processRawPosition(rawPositions);
    await _firestoreHelper.saveCheckOut(currentEntryId!, checkOutTime!, locationList);

    rawPositions.clear();
    locationList = [];
    // notify UI
    notifyListeners();
  }

  List<LocationModel> processRawPosition(List<(Position, DateTime)> data) {

    List<LocationModel> result = [];
    int start = 0;
    for (int i = 0; i < data.length; i++) {
      Position position = data[i].$1;
      DateTime timestamp = data[i].$2;

      debugPrint("[$i] Lat: ${position.latitude}, Lng: ${position.longitude}, Time: $timestamp");
    }

    while (start <data.length){
      Position startPosition = data[start].$1;
      DateTime startTime = data[start].$2;
      DateTime endTime = startTime;
      debugPrint(" Start Position: $startPosition - StartTime: {$startTime}\n");
      int end = start;
      while(end+1<data.length) {
        Position nextPosition = data[end+1].$1;
        DateTime nextTime = data[end+1].$2;
        debugPrint(" Next Position: $nextPosition - NextTime: {$nextTime}\n");

        double distance = Geolocator.distanceBetween(
            startPosition.latitude, startPosition.longitude,
            nextPosition.latitude, nextPosition.longitude,
        );

        endTime = nextTime;
        if (distance > 5) {
          start = end + 1;
          break;
        }

        end++;
      }

      Duration duration = endTime.difference(startTime);
      result.add(LocationModel(startPosition.latitude, startPosition.longitude, duration));

      start = end +1 ;
    }

    if (result.isNotEmpty) {
      LocationModel lastLocation = result.last;
      DateTime lastRecordedTime = data.last.$2; // Get the last recorded timestamp
      Duration updatedDuration = checkOutTime!.difference(lastRecordedTime);

      result[result.length - 1] = LocationModel(
        lastLocation.latitude,
        lastLocation.longitude,
        updatedDuration,
      );
    }

    return result;

  }
}
