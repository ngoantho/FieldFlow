import 'package:field_flow/banner.dart';
import 'package:field_flow/homepage/check_in_out_button.dart';
import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:field_flow/providers/position_provider.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class CheckInOutButtonState extends State<CheckInOutButton> with DialogConfirmMixin {
  List<(Position, DateTime)> rawPositions = [];

  void _positionListener() async {
    final currentPosition = context.read<PositionProvider>().currentPosition;
    final currentTime = context.read<PositionProvider>().logTime;
    rawPositions.add((currentPosition!, currentTime!));
    debugPrint('position: ${currentPosition.toString()} at $currentTime');
  }

  void _resetCheckOut(BuildContext context) {
    context.read<TimeTracker>().checkedIn = false;
    context.read<TimeTracker>().checkedOut = false;
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

    return ElevatedButton(
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
    );
  }
}