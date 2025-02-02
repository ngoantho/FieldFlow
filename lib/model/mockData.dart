import 'package:field_flow/model/CheckEntryModel.dart';
import 'package:field_flow/model/DayModel.dart';
import 'package:field_flow/model/LocationModel.dart';
import 'package:field_flow/model/WeekModel.dart';

final MockWeekList = [
  WeekModel([
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:12, hours: 8)), DateTime.now().subtract(Duration(days: 12))), [LocationModel(47.6205, -122.3493, 3), LocationModel(47.6097, -122.3410, 3), LocationModel(47.6094, -122.3180, 2)]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:11, hours: 8)), DateTime.now().subtract(Duration(days: 11))), [LocationModel(47.6205, -122.3493, 3), LocationModel(47.6097, -122.3410, 3), LocationModel(47.6094, -122.3180, 2)]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:10, hours: 8)), DateTime.now().subtract(Duration(days: 10))), [LocationModel(47.6205, -122.3493, 3), LocationModel(47.6097, -122.3410, 3), LocationModel(47.6094, -122.3180, 2)]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:9, hours: 8)), DateTime.now().subtract(Duration(days: 9))), [LocationModel(47.6205, -122.3493, 3), LocationModel(47.6097, -122.3410, 3), LocationModel(47.6094, -122.3180, 2)]),
    DayModel(CheckEntryModel(DateTime.now().subtract(Duration(days:8, hours: 8)), DateTime.now().subtract(Duration(days: 8))), [LocationModel(47.6205, -122.3493, 3), LocationModel(47.6097, -122.3410, 3), LocationModel(47.6094, -122.3180, 2)]),
  ])
];