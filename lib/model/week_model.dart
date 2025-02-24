import 'package:intl/intl.dart';

import 'day_model.dart';

class WeekModel{
  List<DayModel> dayList;

  WeekModel(this.dayList);

  double get getWorkHour{
    return dayList.fold(0, (sum, day) =>
      sum + (day.checkEntry.checkOutTime!).difference(day.checkEntry.checkInTime!).inHours);
  }

  String getWeekRange() {
    if (dayList.isEmpty) return "No data available";

    // Get the first day's check-in date
    DateTime firstDay = dayList.first.checkEntry.checkInTime!;

    // Calculate Monday of that week
    DateTime startOfWeek = firstDay.subtract(Duration(days: firstDay.weekday - 1));

    // Calculate Sunday of that week
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Format the dates (e.g., 2/17/2025 - 2/23/2025)
    String formattedStart = DateFormat('MM/dd/yyyy').format(startOfWeek);
    String formattedEnd = DateFormat('MM/dd/yyyy').format(endOfWeek);

    return "$formattedStart - $formattedEnd";
  }
  @override
  String toString() {
    return 'Week Report: \n'
        '${getWeekRange()} \n'
        'Total Work Hour: $getWorkHour';
  }
}