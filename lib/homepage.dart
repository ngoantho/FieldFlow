import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/mixins/dialog_confirm.dart';
import 'package:field_flow/mixins/navigate_mixin.dart';
import 'package:field_flow/model/check_entry_model.dart';
import 'package:field_flow/week_list_history_page.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with BuildAppBar, NavigateMixin, DialogConfirmMixin {
  bool? checkedIn;
  final checkEntryModel = CheckEntryModel();

  void checkIn() {
    setState(() {
      checkedIn = true;
      checkEntryModel.checkIn();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tracking Location',
        textAlign: TextAlign.center,
      ),
      duration: Duration(hours: 8),
    ));
  }

  void checkOut() async {
    bool confirmed =
        await showConfirmDialog(context: context, title: 'Check Out?');

    if (confirmed) {
      setState(() {
        checkedIn = false;
        checkEntryModel.checkOut();
      });

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
  }

  void _checkInAgain() {
    setState(() {
      checkEntryModel.reset();
      checkedIn = null;
    });

    Navigator.pop(context);
  }

  bool get alreadyCheckedOut => checkedIn == false;
  DateTime? get checkInTime => checkEntryModel.checkInTime;
  DateTime? get checkOutTime => checkEntryModel.checkOutTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(title: 'FieldFlow'),
        drawer: alreadyCheckedOut ? ElevatedButton(
            onPressed: _checkInAgain, child: Text('Check In again')) : null,
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
              true => "Checked In on ${checkInTime?.getMmDdYyyy()} at ${checkInTime?.getHHmmss()}",
              false => "Checked Out on ${checkOutTime?.getMmDdYyyy()} at ${checkOutTime?.getHHmmss()}",
              null => "",
            })
          ],
        )));
  }
}
