import 'package:field_flow/mock_data/mock_locations.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TimeTracker with ChangeNotifier {
  DateTime? checkInTime;
  DateTime? checkOutTime;
  DateTime? lastCheckOutTime;
  List<WeekModel> weekList = [];
  WeekModel? currentWeek;
  List<LocationModel> locationList = [];

  void checkIn() {
    checkInTime = DateTime.now().subtract(Duration(hours: 8));
    notifyListeners();
  }

  void checkOut(List<(Position, DateTime)> rawPositions) {
    checkOutTime = DateTime.now();
    lastCheckOutTime = checkOutTime;
    List<(Position, DateTime)> data = rawPositions;

    locationList = processRawPosition(data);
    if (checkInTime == null || checkOutTime == null) return;

    // fill in times
    final CheckEntryModel checkEntry = CheckEntryModel(checkInTime, checkOutTime);

    // create day model
    final newDay = DayModel(checkEntry, locationList);

    rawPositions.clear();
    // add day to week
    addDayToWeek(newDay);
    // delay
    checkInTime = null;
    checkOutTime = null;
    locationList = [];
    // notify UI
    notifyListeners();
  }

  addDayToWeek(DayModel day) {
    DateTime checkInDate = day.checkEntry.checkInTime!;

    /*
      .weekday returns a value from 1 to 7
      .weekday - 1 gets how many days have passed since monday
      subtract .weekday - 1 moves the date back to Monday of that week
     */
    DateTime startWeekFlag = checkInDate.subtract(Duration(days: checkInDate.weekday - 1));

    DateTime endWeekFlag = startWeekFlag.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    if (currentWeek == null || currentWeek!.dayList.isEmpty || checkInDate.isAfter(endWeekFlag)) {
      // new week
      if (currentWeek != null && currentWeek!.dayList.isNotEmpty) {
        weekList.add(currentWeek!);
      }
      currentWeek = WeekModel([day]);
      weekList.add(currentWeek!);
    } else {
      // add to existing week
      currentWeek!.dayList.add(day);
    }
  }

  List<LocationModel> processRawPosition(List<(Position, DateTime)> data) {

    List<LocationModel> result = [];
    int start = 0;

    while (start <data.length){
      Position startPosition = data[start].$1;
      DateTime startTime = data[start].$2;
      DateTime endTime = startTime;
      debugPrint(" Start Position: ${startPosition} - StartTime: {$startTime}\n");
      int end = start;
      while(end+1<data.length) {
        Position nextPosition = data[end+1].$1;
        DateTime nextTime = data[end+1].$2;
        debugPrint(" Next Position: ${nextPosition} - NextTime: {$nextTime}\n");

        double distance = Geolocator.distanceBetween(
            startPosition.latitude, startPosition.longitude,
            nextPosition.latitude, nextPosition.longitude,
        );

        endTime = nextTime;
        if (distance > 50) {
          start = end + 1;
          break;
        };

        end++;
      }

      Duration duration = endTime.difference(startTime);
      result.add(LocationModel(startPosition.latitude, startPosition.longitude, duration));

      start = end +1 ;
    }
    return result;

  }
}
