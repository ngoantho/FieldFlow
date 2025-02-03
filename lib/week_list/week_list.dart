import 'package:field_flow/day_list/day_list_history_page.dart';
// import 'package:field_flow/mock_data/mock_data.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekList extends StatelessWidget {
  const WeekList({super.key});

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTracker>();

    debugPrint("Week List Length: ${timeTracker.weekList.length}");
    return ListView.builder(
        itemCount: timeTracker.weekList.length,
        itemBuilder: (context, index) => Padding(padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child:_WeekListItem(timeTracker.weekList[index]))
    );
  }
}

class _WeekListItem extends StatelessWidget{
  final WeekModel week;
  const _WeekListItem(this.week);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
      ),
      child: Text(week.toString()),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DayListHistoryPage(weekModel: week),
          )
        );
      },
    );
  }
}
