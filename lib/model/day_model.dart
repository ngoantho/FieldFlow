import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/location_model.dart';

class DayModel{
  final CheckEntryModel checkEntry;
  final List<LocationModel> locationList;

  DayModel(this.checkEntry,this.locationList);

  String get getMmDdYyyy{
    return checkEntry.checkInTime!.getMmDdYyyy();
  }

  String get dayOfWeek{
    return checkEntry.checkInTime!.getDayOfWeek();
  }
}