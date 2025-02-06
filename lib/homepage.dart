import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:field_flow/mixins/navigate_mixin.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/providers/position_provider.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:field_flow/week_list/week_list_history_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:field_flow/banner.dart';

class Homepage extends StatefulWidget {
  final Duration? checkInAgain;

  const Homepage({this.checkInAgain, super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with BuildAppBar, NavigateMixin, DialogConfirmMixin {
  late Duration checkInAgain;
  final rawPositions = <(Position, DateTime)>[];

  void _positionListener() async {
    final currentPosition = context.read<PositionProvider>().currentPosition;
    final currentTime = DateTime.now();
    rawPositions.add((currentPosition!, currentTime));
    debugPrint('position: ${currentPosition.toString()} at $currentTime');
  }

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration untilMidnight = midnight.difference(now);
    checkInAgain = widget.checkInAgain ?? untilMidnight;
  }

  void _resetCheckOut(BuildContext context) {
    Future.delayed(checkInAgain, () {
      setState(() {
        context.read<TimeTracker>().checkedIn = false;
        context.read<TimeTracker>().checkedOut = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();
    final positionProvider = context.watch<PositionProvider>();

    checkIn() async {
      final (canTrackPosition, error) = await positionProvider.canTrackPosition;
      if (canTrackPosition) {
        positionProvider.startTracking(_positionListener);
        timeTracker.checkIn();
        FieldFlowBanner.show(context, 'Tracking Location');
      } else {
        debugPrint(error);
        FieldFlowBanner.show(context, error!, [
          TextButton(
              onPressed: () => Geolocator.openAppSettings(),
              child: Text('App Settings')),
          TextButton(
              onPressed: () => Geolocator.openLocationSettings(),
              child: Text('Location Settings'))
        ]);
      }
    }

    checkOut() async {
      bool confirmed =
          await showConfirmDialog(context: context, title: 'Check Out?');
      if (confirmed) {
        positionProvider.stopTracking();
        timeTracker.checkOut(rawPositions);
        setState(() {
          FieldFlowBanner.hide(context);
          _resetCheckOut(context);
        });
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
            if (!timeTracker.checkedOut)
              ElevatedButton(
                onPressed: switch (timeTracker.checkedIn) {
                  true => checkOut,
                  false => checkIn,
                },
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(50),
                    backgroundColor: Colors.lightBlueAccent),
                child: Text(
                  timeTracker.checkedIn ? 'Check Out' : 'Check In',
                ),
              ),
            SizedBox(height: 10),
            Text(switch (timeTracker.checkedOut) {
              true => "Checked Out on ${timeTracker.lastCheckOutTime?.getMmDdYyyy()} at ${timeTracker.lastCheckOutTime?.getHHmmss()}",
              false => switch(timeTracker.checkedIn) {
                true => "Checked In on ${timeTracker.checkInTime?.getMmDdYyyy()} at ${timeTracker.checkInTime?.getHHmmss()}",
                false => ""
              },
            }),
          ],
        )));
  }
}
