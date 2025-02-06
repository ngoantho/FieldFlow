import 'package:field_flow/model/check_entry_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Check in/out', () {
    test('check in', () {
      final model = CheckEntryModel();
      expect(model.checkInTime, isNull);

      model.checkIn();
      expect(model.checkInTime, equals(DateTime.now()));
    });
    test('check out', () {
      final model = CheckEntryModel();
      expect(model.checkOutTime, isNull);

      model.checkOut();
      expect(model.checkOutTime, equals(DateTime.now()));
    });
    test('reset', () {
      final model = CheckEntryModel();
      model.checkInTime = DateTime.now();
      model.checkOutTime = DateTime.now();
      
      model.reset();
      expect(model.checkInTime, isNull);
      expect(model.checkOutTime, isNull);
    });
  });
  group('format datetime as HH:mm:ss', () {
    test('DateTime extension', () {
      final testDate = DateTime.now();
      final timeFormat = RegExp(r'^\d{2}:\d{2}:\d{2}$');
      expect(testDate.getHHmmss(), matches(timeFormat));
    });
  });
}