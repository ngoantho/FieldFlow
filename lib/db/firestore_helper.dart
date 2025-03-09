import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save a check-in entry
  Future<String> saveCheckIn(DateTime checkInTime) async {

    User? user = _auth.currentUser;
    String userId = user!.uid;
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    String role = userDoc['role'];

    DocumentReference docRef = _firestore.collection('check_entries').doc();
    await docRef.set({
      'userId': userId,
      'role': role,
      'checkInTime': checkInTime.toIso8601String(),
      'checkedIn': true,
      'checkedOut': false,
      'locations': [],
    });
    return docRef.id;
  }

  /// Update a check-out entry with location data
  Future<void> saveCheckOut(String entryId, DateTime checkOutTime,
      List<LocationModel> locations) async {
    await _firestore.collection('check_entries').doc(entryId).update({
      'checkOutTime': checkOutTime.toIso8601String(),
      'checkedOut': true,
      'locations': locations
          .map((loc) => {
                'latitude': loc.latitude,
                'longitude': loc.longitude,
                'duration': loc.duration.inSeconds,
              })
          .toList(),
    });
  }

  /// Fetch all days (check-in/out) from Firestore
  Stream<List<DayModel>> getDaysStream({required String userId}) {
    return _firestore
        .collection('check_entries')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            var data = doc.data();

            if (data['checkOutTime'] == null ||
                (data['locations'] as List<dynamic>).isEmpty) {
              return null;
            }

            return DayModel(
              CheckEntryModel(
                DateTime.parse(data['checkInTime']),
                data['checkOutTime'] != null
                    ? DateTime.parse(data['checkOutTime'])
                    : null,
              ),
              (data['locations'] as List<dynamic>).map((loc) {
                return LocationModel(
                  loc['latitude'],
                  loc['longitude'],
                  Duration(seconds: loc['duration']),
                );
              }).toList(),
            );
          })
          .where((day) => day != null)
          .cast<DayModel>()
          .toList();
    });
  }

  /// Fetch weeks grouped from Firestore
  Stream<List<WeekModel>> getWeeksStream({required String userId}) {
    return getDaysStream(userId: userId).map((days) {
      Map<String, List<DayModel>> groupedByWeek = {};

      for (var day in days) {
        DateTime checkInDate = day.checkEntry.checkInTime!;
        DateTime startOfWeek =
            checkInDate.subtract(Duration(days: checkInDate.weekday - 1));
        String weekKey =
            "${startOfWeek.year}-${startOfWeek.month}-${startOfWeek.day}";

        groupedByWeek.putIfAbsent(weekKey, () => []).add(day);
        debugPrint('');
      }

      return groupedByWeek.values.map((days) => WeekModel(days)).toList();
    });
  }

  Future<DocumentSnapshot> getUser(String userId) async {
    return _firestore.collection('users').doc(userId).get();
  }

  Future<void> createUser(String userId, String? name, String? email) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name ?? 'Unknown',
      'email': email,
      'role': null,
    });
  }

  /// Fetch all users from Firestore
  Future<Map<String, String>> getUsers() async {
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
    return {for (var doc in usersSnapshot.docs) doc.id: doc['name'] ?? 'Unknown'};
  }

  /// Fetch work hour report data for selected users within a date range
  Future<List<Map<String, dynamic>>> getWorkHourReport(
      {required List<String> userIds, required DateTime startDate, required DateTime endDate}) async {
    if (userIds.isEmpty) return [];

    QuerySnapshot checkEntriesSnapshot = await _firestore
        .collection('check_entries')
        .where('userId', whereIn: userIds)
        .where('checkInTime', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('checkInTime', isLessThanOrEqualTo: endDate.toIso8601String())
        .get();

    List<Map<String, dynamic>> report = [];
    for (var doc in checkEntriesSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String userId = data['userId'];
      DateTime checkInTime = DateTime.parse(data['checkInTime']);
      DateTime? checkOutTime =
      data['checkOutTime'] != null ? DateTime.parse(data['checkOutTime']) : null;
      int workHours = checkOutTime != null ? checkOutTime.difference(checkInTime).inHours : 0;

      report.add({
        'checkInTime': data['checkInTime'],
        'userId': userId,
        'workHours': workHours,
      });
    }
    return report;
  }
}
