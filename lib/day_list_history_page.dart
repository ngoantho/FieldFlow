import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';
import 'package:field_flow/mixins/build_app_bar.dart';

import 'day_list.dart';


class DayListHistoryPage extends StatelessWidget {
  final WeekModel weekModel;

  const DayListHistoryPage({super.key, required this.weekModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Week ${weekModel.dayList.first.getMmDdYyyy} - ${weekModel.dayList.last.getMmDdYyyy} Report'
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: DayList(weekModel: weekModel),
          ),
    );
  }
}
