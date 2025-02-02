import 'package:field_flow/model/day_model.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:flutter/material.dart';

class DayList extends StatelessWidget {
  final WeekModel weekModel;

  const DayList({super.key, required this.weekModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: weekModel.dayList.length ,
          itemBuilder: (context, index) => Padding(padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: _DayList(weekModel.dayList[index]))
      );
  }
}

class _DayList extends StatelessWidget {
  final DayModel dayModel;

  const _DayList(this.dayModel);

  dynamic get workHour{
    return (dayModel.checkEntry.checkOutTime!).difference(dayModel.checkEntry.checkInTime!).inHours;
  }
  @override
  Widget build(BuildContext context){
    
    return ElevatedButton(
        onPressed: (){},
        child: Text('${dayModel.dayOfWeek} - ${dayModel.getMmDdYyyy}\n'
            'Work Hours: $workHour', textAlign: TextAlign.center,));

  }
}
