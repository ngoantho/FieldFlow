import 'package:field_flow/mock_data/mock_locations.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';

class TimeTracker with ChangeNotifier {
  DateTime? checkInTime;
  DateTime? checkOutTime;
  DateTime? lastCheckOutTime;
  List<WeekModel> weekList = [];
  WeekModel? currentWeek;

  void checkIn() {
    checkInTime = DateTime.now().subtract(Duration(hours: 8));
    notifyListeners();
  }

  void checkOut() {
    checkOutTime = DateTime.now();
    lastCheckOutTime = checkOutTime;

    if (checkInTime == null || checkOutTime == null) return;

    // fill in times
    final CheckEntryModel checkEntry = CheckEntryModel(checkInTime, checkOutTime);

    // create day model
    final newDay = DayModel(checkEntry, mockLocations);

    // add day to week
    addDayToWeek(newDay);
    
    // delay
    checkInTime = null;
    checkOutTime = null;

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
}