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
  Map<String, List<Map<String, dynamic>>> _groupedReportData = {};
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
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var entry in report) {
      DateTime checkInDate = DateTime.parse(entry['checkInTime']);
      String formattedDate = DateFormat('EEEE (MM-dd-yyyy)').format(checkInDate);

      if (!groupedData.containsKey(formattedDate)) {
        groupedData[formattedDate] = [];
      }
      groupedData[formattedDate]!.add(entry);
    }
    setState(() {
      _userNames = users;
      _groupedReportData = groupedData;
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
                children: _groupedReportData.entries.map((entry) {
                  String dateHeader = entry.key; // "Tuesday (03-05-2024)"
                  List<Map<String, dynamic>> users = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateHeader,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ...users.map((userEntry) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "- ${_userNames[userEntry['userId']] ?? 'Unknown'} worked ${userEntry['workHours']} hours",
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 10), 
                    ],);}).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
