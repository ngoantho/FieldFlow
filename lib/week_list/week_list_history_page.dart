import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/week_list/choose_worker_page.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';

class WeekListHistoryPage extends StatelessWidget with BuildAppBar {
  const WeekListHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildAppBar(title: 'Week Report'),
          body: TabBarView(children: [const WeekList(), ChooseWorkerPage()]),
          bottomNavigationBar: TabBar(tabs: [
            Tab(text: 'Worker'),
            Tab(
              text: 'Manager',
            )
          ]),
        ));
  }
}
