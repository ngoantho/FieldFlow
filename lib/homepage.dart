import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:field_flow/mixins/navigate_mixin.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/time_tracker_provider.dart';
import 'package:field_flow/week_list_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with BuildAppBar, NavigateMixin, DialogConfirmMixin {
  void _checkIn() {
    final timeTracker = context.read<TimeTracker>();

    setState(() {
      timeTracker.checkIn();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tracking Location',
        textAlign: TextAlign.center,
      ),
      duration: Duration(hours: 8),
    ));
  }

  void _checkOut() async {
    final timeTracker = context.read<TimeTracker>();
    bool confirmed =
        await showConfirmDialog(context: context, title: 'Check Out?');

    if (confirmed) {
      setState(() {
        timeTracker.checkOut();
      });

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
  }

  DateTime? get _checkInTime {
    final timeTracker = context.watch<TimeTracker>();
    return timeTracker.checkInTime;
  }

  DateTime? get _checkOutTime {
    final timeTracker = context.watch<TimeTracker>();
    return timeTracker.checkOutTime;
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();

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
            ElevatedButton(
              // onPressed: switch (timeTracker.checkedIn) {
              //   null => () {
              //       timeTracker.checkIn();
              //       setState(() {});
              //     },
              //   true => () {
              //       timeTracker.checkOut();
              //       setState(() {});
              //     },
              //   false => null, // already checked out
              // },
              onPressed: () {
                if (timeTracker.checkInTime == null) {
                  timeTracker.checkIn();
                } else {
                  timeTracker.checkOut();
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(50),
                  backgroundColor: Colors.lightBlueAccent),
              // child: Text(switch (timeTracker.checkedIn) {
              //   null => 'Check In',
              //   true => 'Check Out',
              //   false => '',
              // })
              child: Text(
                timeTracker.checkInTime == null ? 'Check In' : 'Check Out',
              ),
            ),
            SizedBox(height: 10),
            Text(timeTracker.checkInTime != null
                ? "Checked In at ${timeTracker.checkInTime}"
                : timeTracker.checkOutTime != null ||
                        timeTracker.lastCheckOutTime != null
                    ? "Checked Out at ${timeTracker.lastCheckOutTime}"
                    : "check out not working"),
          ],
        )));
  }
}
