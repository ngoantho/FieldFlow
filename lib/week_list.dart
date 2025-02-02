import 'package:field_flow/model/mock_data.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';

class WeekList extends StatelessWidget {
  const WeekList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mockWeekList.length,
        itemBuilder: (context, index) => _WeekListItem(mockWeekList[index])
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
      onPressed: () {},
    );
  }
}
