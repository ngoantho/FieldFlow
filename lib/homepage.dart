import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:field_flow/mixins/navigate_mixin.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/time_tracker_provider.dart';
import 'package:field_flow/week_list_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final Duration? checkInAgain;
  final Duration? closeTrackingMsg;

  const Homepage({this.checkInAgain, this.closeTrackingMsg, super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with BuildAppBar, NavigateMixin, DialogConfirmMixin {
  bool checkedOut = false;
  late Duration checkInAgain;
  late Duration closeTrackingMsg;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration untilMidnight = midnight.difference(now);
    checkInAgain = widget.checkInAgain ?? untilMidnight;

    closeTrackingMsg = widget.closeTrackingMsg ?? Duration(hours: 8);
  }

  void _resetCheckOut() {
    Future.delayed(checkInAgain, () {
      if (mounted) {
        setState(() {
          checkedOut = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();

    checkIn() {
      timeTracker.checkIn();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Tracking Location',
          textAlign: TextAlign.center,
        ),
        duration: closeTrackingMsg,
      ));
    }

    checkOut() async {
      bool confirmed =
          await showConfirmDialog(context: context, title: 'Check Out?');
      if (confirmed) {
        timeTracker.checkOut();
        setState(() {
          checkedOut = true;
        });
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        _resetCheckOut();
      }
    }

    return Scaffold(
        appBar: buildAppBar(title: 'FieldFlow'),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              navigateTo(context: context, widget: WeekListHistoryPage());
            },
            child: Text('Week Report')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!checkedOut)
              ElevatedButton(
                onPressed: switch (timeTracker.checkInTime == null) {
                  true => checkIn,
                  false => checkOut,
                },
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(50),
                    backgroundColor: Colors.lightBlueAccent),
                child: Text(
                  timeTracker.checkInTime == null ? 'Check In' : 'Check Out',
                ),
              ),
            SizedBox(height: 10),
            Text(switch (timeTracker.checkInTime != null) {
              true =>
                "Checked In on ${timeTracker.checkInTime?.getMmDdYyyy()} at ${timeTracker.checkInTime?.getHHmmss()}",
              false => switch (timeTracker.checkOutTime != null ||
                    timeTracker.lastCheckOutTime != null) {
                  true =>
                    "Checked Out on ${timeTracker.lastCheckOutTime?.getMmDdYyyy()} at ${timeTracker.lastCheckOutTime?.getHHmmss()}",
                  false => "",
                },
            }),
          ],
        )));
  }
}
