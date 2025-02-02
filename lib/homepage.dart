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
  void checkIn() {
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

  void checkOut() async {
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

  void _checkInAgain() {
    final timeTracker = context.read<TimeTracker>();

    setState(() {
      timeTracker.checkInTime = null;
      timeTracker.checkOutTime = null;
      timeTracker.checkedIn = null;
    });

    Navigator.pop(context);
  }

  bool get alreadyCheckedOut {
    final timeTracker = context.read<TimeTracker>();
    return timeTracker.checkedIn == false;
  }

  DateTime? get checkInTime {
    final timeTracker = context.read<TimeTracker>();
    return timeTracker.checkInTime;
  }
  DateTime? get checkOutTime {
    final timeTracker = context.read<TimeTracker>();
    return timeTracker.checkOutTime;
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();

    return Scaffold(
        appBar: buildAppBar(title: 'FieldFlow'),
        drawer: alreadyCheckedOut ? ElevatedButton(
            onPressed: _checkInAgain, child: Text('Check In again')) : null,
        floatingActionButton: ElevatedButton(
            onPressed: () {
              navigateTo(context: context, widget: WeekListHistoryPage());
            },
            child: Text('Week Report')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !alreadyCheckedOut
                ? ElevatedButton(
                    onPressed: switch (timeTracker.checkedIn) {
                      null => checkIn,
                      true => checkOut,
                      false => null, // already checked out
                    },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(50),
                        backgroundColor: Colors.lightBlueAccent),
                    child: Text(switch (timeTracker.checkedIn) {
                      null => 'Check In',
                      true => 'Check Out',
                      false => '',
                    }))
                : Container(),
            SizedBox(height: 10),
            Text(switch (timeTracker.checkedIn) {
              true => "Checked In on ${checkInTime?.getMmDdYyyy()} at ${checkInTime?.getHHmmss()}",
              false => "Checked Out on ${checkOutTime?.getMmDdYyyy()} at ${checkOutTime?.getHHmmss()}",
              null => "",
            })
          ],
        )));
  }
}
