import 'package:field_flow/model/day_model.dart';
import 'package:flutter/material.dart';

class DayDetail extends StatelessWidget {
  final DayModel dayModel;
  const DayDetail({super.key, required this.dayModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: Text(
                "${dayModel.dayOfWeek} - ${dayModel.getMmDdYyyy} - Detail Report \n"
                "Check-in at: ${dayModel.checkEntry.checkInTime} \n"
                "Check-out at: ${dayModel.checkEntry.checkOutTime}\n\n\n")),
        ...dayModel.locationList.map((location) {
          return Row(
            children: [
              Expanded(
                  child: Text(
                      '           You spent ${location.duration} hours at Location: ${location.latitude} - ${location.longitude}\n\n\n',
                      textAlign: TextAlign.justify)),
            ],
          );
        }),
      ],
    ));
    // return SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             .start,
    //       children:[
    //         Padding(
    //           padding: EdgeInsets.all(8.0),
    //           child: Text(
    //               "${dayModel.dayOfWeek} - ${dayModel.getDdMmYyyy} - Detail Report\n"
    //                                   "Check-in at: ${dayModel.checkEntry.checkInTime}\n"
    //                                   "Check-out at: ${dayModel.checkEntry.checkOutTime}"
    //           ),
    //         ),
    //         //Workout Exercise List out
    //         ...dayModel.locationList.map((location) {
    //           return Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                     'You spent ${location.duration.inHours} hours at Location: ${location.latitude} - ${location.longitude} \n'
    //                 ),
    //               ),
    //
    //             ],
    //           );
    //         }).toList(),
    //
    //       ],
    //
    //
    //     )
    // );
  }
}
