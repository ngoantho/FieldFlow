import 'package:field_flow/model/check_entry_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckEntryModel Test Group', () {
    test('Test if Check In successfully captured now() time', () {
      final model = CheckEntryModel();
      expect(model.checkInTime, isNull);

      model.checkIn();
      expect(model.checkInTime, equals(DateTime.now()));
    });
    test('Test Check Out successfully captured now() time', () {
      final model = CheckEntryModel();
      expect(model.checkOutTime, isNull);

      model.checkOut();
      expect(model.checkOutTime, equals(DateTime.now()));
    });
    test('Test if model successful reset its variable after called reset()', () {
      final model = CheckEntryModel();
      model.checkInTime = DateTime.now();
      model.checkOutTime = DateTime.now();
      
      model.reset();
      expect(model.checkInTime, isNull);
      expect(model.checkOutTime, isNull);
    });
  });
  group('format datetime as HH:mm:ss', () {
    test('Test if getHHmmss() returns expected time format as HH:mm:ss', () {
      final testDate = DateTime.now();
      final timeFormat = RegExp(r'^\d{2}:\d{2}:\d{2}$');
      expect(testDate.getHHmmss(), matches(timeFormat));
    });
  });
}