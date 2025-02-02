import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with BuildAppBar {
  bool checkedIn = false;

  void checkInOut() {
    setState(() {
      checkedIn = !checkedIn; // toggle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(title: 'FieldFlow'),
        body: Center(
          child: Stack(children: [
            ElevatedButton(
                onPressed: checkInOut,
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(50),
                    backgroundColor: Colors.lightBlueAccent
                ),
                child: Text(!checkedIn ? 'Check In' : 'Check Out')
            ),
          ],)
        )
    );
  }
}
