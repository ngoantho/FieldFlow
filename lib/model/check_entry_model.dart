import 'package:intl/intl.dart';

class CheckEntryModel{
  DateTime? checkInTime;
  DateTime? checkOutTime;

  CheckEntryModel([this.checkInTime, this.checkOutTime]);

  void checkIn(){
    checkInTime = DateTime.now();
  }

  void checkOut(){
    checkOutTime = DateTime.now();
  }

  void reset() {
    checkInTime = null;
    checkOutTime = null;
  }
}

extension FormatMmDdYyyy on DateTime {
  String getMmDdYyyy() {
    return DateFormat('MM/dd/yyyy').format(this);
  }
}

extension FormatHHmmss on DateTime {
  String getHHmmss() {
    return DateFormat('HH:mm:ss').format(this);
  }
}

extension DayOfWeek on DateTime {
  String getDayOfWeek() {
    return DateFormat('EEEE').format(this);
  }
}