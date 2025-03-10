import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';

import 'day_list.dart';


class DayListHistoryPage extends StatelessWidget {
  final WeekModel weekModel;

  const DayListHistoryPage({super.key, required this.weekModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // '${weekModel.dayList.first.getMmDdYyyy} - ${weekModel.dayList.last.getMmDdYyyy}'
          weekModel.getWeekRange()
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: DayList(weekModel: weekModel),
          ),
    );
  }
}
