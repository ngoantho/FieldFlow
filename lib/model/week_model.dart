import 'day_model.dart';

class WeekModel{
  List<DayModel> dayList;

  WeekModel(this.dayList);

  double get getWorkHour{
    return dayList.fold(0, (sum, day) =>
      sum + (day.checkEntry.checkOutTime!).difference(day.checkEntry.checkInTime!).inHours);
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Week Report: \n'
        '${dayList[0].getMmDdYyyy} - ${dayList.last.getMmDdYyyy} \n'
        'Total Work Hour: $getWorkHour';
  }
}