import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:field_flow/week_list/week_list_history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'homepage/check_in_out_button.dart';
import 'homepage/checked_in_out_text.dart';

class Homepage extends StatefulWidget {
  final Duration? checkInAgain;

  const Homepage({this.checkInAgain, super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with BuildAppBar, DialogConfirmMixin {
  late Duration checkInAgain;
  final rawPositions = <(Position, DateTime)>[];

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration untilMidnight = midnight.difference(now);
    checkInAgain = widget.checkInAgain ?? untilMidnight;
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();

    return FutureBuilder(future: (() async {
      User? user = FirebaseAuth.instance.currentUser;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      return userDoc['role'];
    })(), builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Scaffold(
            appBar: buildAppBar(title: 'FieldFlow'),
            body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
          appBar: buildAppBar(title: 'FieldFlow', subtitle: snapshot.data),
          floatingActionButton: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => WeekListHistoryPage()));
              },
              child: Text('Week Report')),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!timeTracker.checkedOut) CheckInOutButton(),
              SizedBox(height: 10),
              CheckedInOutText(),
            ],
          )));
    });
  }
}
