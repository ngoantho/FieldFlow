import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a check-in entry
  Future<String> saveCheckIn(DateTime checkInTime) async {
    DocumentReference docRef = _firestore.collection('check_entries').doc();
    await docRef.set({
      'checkInTime': checkInTime.toIso8601String(),
      'checkedIn': true,
      'checkedOut': false,
      'locations': [],
    });
    return docRef.id;
  }

  /// Update a check-out entry with location data
  Future<void> saveCheckOut(String entryId, DateTime checkOutTime, List<LocationModel> locations) async {
    await _firestore.collection('check_entries').doc(entryId).update({
      'checkOutTime': checkOutTime.toIso8601String(),
      'checkedOut': true,
      'locations': locations.map((loc) => {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
        'duration': loc.duration.inSeconds,
      }).toList(),
    });
  }

  /// Fetch all days (check-in/out) from Firestore
  Stream<List<DayModel>> getDaysStream() {
    return _firestore.collection('check_entries').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return DayModel(
          CheckEntryModel(
            DateTime.parse(data['checkInTime']),
            data['checkOutTime'] != null ? DateTime.parse(data['checkOutTime']) : null,
          ),
          (data['locations'] as List<dynamic>).map((loc) {
            return LocationModel(
              loc['latitude'],
              loc['longitude'],
              Duration(seconds: loc['duration']),
            );
          }).toList(),
        );
      }).toList();
    });
  }

  /// Fetch weeks grouped from Firestore
  Stream<List<WeekModel>> getWeeksStream() {
    return getDaysStream().map((days) {
      Map<String, List<DayModel>> groupedByWeek = {};

      for (var day in days) {
        DateTime checkInDate = day.checkEntry.checkInTime!;
        DateTime startOfWeek = checkInDate.subtract(Duration(days: checkInDate.weekday - 1));
        String weekKey = "${startOfWeek.year}-${startOfWeek.month}-${startOfWeek.day}";

        groupedByWeek.putIfAbsent(weekKey, () => []).add(day);
      }

      return groupedByWeek.values.map((days) => WeekModel(days)).toList();
    });
  }
}
