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
  bool checkedOut = false;

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
            if (!checkedOut)
              ElevatedButton(
                onPressed: () async {
                  if (timeTracker.checkInTime == null) {
                    timeTracker.checkIn();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Tracking Location',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(hours: 8),
                    ));
                  } else {
                    bool confirmed = await showConfirmDialog(
                        context: context, title: 'Check Out?');
                    if (confirmed) {
                      timeTracker.checkOut();
                      setState(() {
                        checkedOut = true;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    }
                  }
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
            Text(timeTracker.checkInTime != null
                ? "Checked In on ${timeTracker.checkInTime?.getMmDdYyyy()} at ${timeTracker.checkInTime?.getHHmmss()}"
                : timeTracker.checkOutTime != null ||
                        timeTracker.lastCheckOutTime != null
                    ? "Checked Out on ${timeTracker.lastCheckOutTime?.getMmDdYyyy()} at ${timeTracker.lastCheckOutTime?.getHHmmss()}"
                    : ""),
          ],
        )));
  }
}
