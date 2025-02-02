import 'package:field_flow/week_list.dart';
import 'package:flutter/material.dart';

class WeekListHistoryPage extends StatelessWidget {
  const WeekListHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const WeekList(),
    );
  }
}
