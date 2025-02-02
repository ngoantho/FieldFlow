import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:intl/intl.dart';

class DayModel{
  final CheckEntryModel checkEntry;
  final List<LocationModel> locationList;

  DayModel(this.checkEntry,this.locationList);

  String get getDdMmYyyy{
      return DateFormat('MM/dd/yyyy').format(checkEntry.checkInTime!);
  }

  String get dayOfWeek{
    return DateFormat('EEEE').format(checkEntry.checkInTime!);
  }
}