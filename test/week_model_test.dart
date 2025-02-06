import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('get work hours', () {
    test('one day = 8 hours', () {
      final days = <DayModel>[
        DayModel(
            CheckEntryModel(DateTime.now().copyWith(hour: 9),
                DateTime.now().copyWith(hour: 17)),
            [])
      ];
      final week = WeekModel(days);

      final actual = week.getWorkHour;
      final expected = 8;
      expect(actual, equals(expected));
    });
    test('two days = 16 hours', () {
      final days = <DayModel>[
        DayModel(
            CheckEntryModel(DateTime.now().copyWith(hour: 9),
                DateTime.now().copyWith(hour: 17)),
            []),
        DayModel(
            CheckEntryModel(
                DateTime.now().add(Duration(days: 1)).copyWith(hour: 9),
                DateTime.now().add(Duration(days: 1)).copyWith(hour: 17)),
            [])
      ];
      final week = WeekModel(days);

      final actual = week.getWorkHour;
      final expected = 16;
      expect(actual, equals(expected));
    });
  });

  test('toString', () {
    final days = <DayModel>[
      DayModel(
          CheckEntryModel(DateTime(2025, 2, 3, 9), DateTime(2025, 2, 3, 17)),
          [])
    ];
    final week = WeekModel(days);

    final actual = week.toString();
    final expected =
        "Week Report: \n02/03/2025 - 02/03/2025 \nTotal Work Hour: 8.0";
    expect(actual, equals(expected));
  });
}
