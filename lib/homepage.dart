import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/mixins/navigate_mixin.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/week_list_history_page.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with BuildAppBar, NavigateMixin {
  bool? checkedIn;
  final checkEntryModel = CheckEntryModel();

  void checkIn() {
    setState(() {
      checkedIn = true;
      checkEntryModel.checkIn();
    });
  }

  void checkOut() {
    setState(() {
      checkedIn = false;
      checkEntryModel.checkOut();
    });
  }

  bool get alreadyCheckedOut => checkedIn == false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(title: 'FieldFlow'),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              navigateTo(context: context, widget: WeekListHistoryPage());
            },
            child: Text('Week Report')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !alreadyCheckedOut
                ? ElevatedButton(
                    onPressed: switch (checkedIn) {
                      null => checkIn,
                      true => checkOut,
                      false => null, // already checked out
                    },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(50),
                        backgroundColor: Colors.lightBlueAccent),
                    child: Text(switch (checkedIn) {
                      null => 'Check In',
                      true => 'Check Out',
                      false => '',
                    }))
                : Container(),
            SizedBox(height: 10),
            Text(switch (checkedIn) {
              true => "Checked In at ${checkEntryModel.checkInTime}",
              false => "Checked Out at ${checkEntryModel.checkOutTime}",
              null => "",
            })
          ],
        )));
  }
}
