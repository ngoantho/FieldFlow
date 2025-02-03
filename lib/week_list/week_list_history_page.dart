import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';

class WeekListHistoryPage extends StatelessWidget with BuildAppBar {
  const WeekListHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Week Report'),
      body: const WeekList(),
    );
  }
}
