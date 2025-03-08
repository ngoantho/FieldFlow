import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:intl/intl.dart';

class ReportResultPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<String> selectedUserIds;

  ReportResultPage({
    required this.startDate,
    required this.endDate,
    required this.selectedUserIds,
  });

  @override
  _ReportResultPageState createState() => _ReportResultPageState();
}

class _ReportResultPageState extends State<ReportResultPage> {
  List<Map<String, dynamic>> _reportData = [];
  Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    final firestoreHelper = Provider.of<FirestoreHelper>(context, listen: false);
    Map<String, String> users = await firestoreHelper.getUsers();
    List<Map<String, dynamic>> report = await firestoreHelper.getWorkHourReport(
      userIds: widget.selectedUserIds,
      startDate: widget.startDate,
      endDate: widget.endDate,
    );

    setState(() {
      _userNames = users;
      _reportData = report;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "From ${DateFormat.yMMMd().format(widget.startDate)} to ${DateFormat.yMMMd().format(widget.endDate)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: _reportData.map((entry) {
                  return ListTile(
                    title: Text("${entry['day']}: ${_userNames[entry['userId']]} - ${entry['workHours']} hours"),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
