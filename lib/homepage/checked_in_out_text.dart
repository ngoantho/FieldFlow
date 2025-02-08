import 'package:field_flow/model/check_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/time_tracker.dart';

class CheckedInOutText extends StatelessWidget {
  const CheckedInOutText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();

    return Text(switch (timeTracker.checkedOut) {
      true => "Checked Out on ${timeTracker.lastCheckOutTime?.getMmDdYyyy()} at ${timeTracker.lastCheckOutTime?.getHHmmss()}",
      false => switch(timeTracker.checkedIn) {
        true => "Checked In on ${timeTracker.checkInTime?.getMmDdYyyy()} at ${timeTracker.checkInTime?.getHHmmss()}",
        false => ""
      },
    });
  }
}