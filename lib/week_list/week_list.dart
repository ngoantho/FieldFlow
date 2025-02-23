import 'package:field_flow/day_list/day_list_history_page.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/firestore_helper.dart';

class WeekList extends StatelessWidget {
  final String id;

  const WeekList({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final firestoreService =
        Provider.of<FirestoreHelper>(context, listen: false);

    return StreamBuilder<List<WeekModel>>(
      stream: firestoreService.getWeeksStream(userId: id),
      builder: (context, snapshot) {
        debugPrint("getWeekStream: $id");
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<WeekModel> weeks = snapshot.data!;

        return ListView.builder(
          itemCount: weeks.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: _WeekListItem(weeks[index]),
          ),
        );
      },
    );
  }
}

class _WeekListItem extends StatelessWidget {
  final WeekModel week;
  const _WeekListItem(this.week);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      child: Text(week.toString()),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DayListHistoryPage(weekModel: week),
        ));
      },
    );
  }
}
