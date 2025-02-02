import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';

final mockWeekList = [
  WeekModel([
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:12, hours: 8)), DateTime.now().subtract(Duration(days: 12))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:11, hours: 8)), DateTime.now().subtract(Duration(days: 11))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:10, hours: 8)), DateTime.now().subtract(Duration(days: 10))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:9, hours: 8)), DateTime.now().subtract(Duration(days: 9))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:8, hours: 8)), DateTime.now().subtract(Duration(days: 8))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
  ]),

  WeekModel([
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:19, hours: 8)), DateTime.now().subtract(Duration(days: 12))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:18, hours: 8)), DateTime.now().subtract(Duration(days: 11))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:17, hours: 8)), DateTime.now().subtract(Duration(days: 10))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:16, hours: 8)), DateTime.now().subtract(Duration(days: 9))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:15, hours: 8)), DateTime.now().subtract(Duration(days: 8))), [LocationModel(47.6205, -122.3493, Duration(hours: 3)), LocationModel(47.6097, -122.3410, Duration(hours: 3)), LocationModel(47.6094, -122.3180, Duration(hours: 2))]),
  ])
];