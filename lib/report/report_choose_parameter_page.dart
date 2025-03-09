import 'package:field_flow/report/user_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/report/report_result_page.dart';
import 'package:field_flow/report/date_range_picker.dart';
class ReportChooseParameterPage extends StatefulWidget {
  @override
  _ReportChooseParameterPageState createState() => _ReportChooseParameterPageState();
}
class _ReportChooseParameterPageState extends State<ReportChooseParameterPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedUserIds = [];
  Map<String, String> _userNames = {}; // userId -> userName mapping
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }
  Future<void> _fetchUsers() async {
    final firestoreHelper = Provider.of<FirestoreHelper>(context, listen: false);
    Map<String, String> users = await firestoreHelper.getUsers();
    setState(() => _userNames = users);
  }
  void _onDateRangeSelected(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });}
  void _onUserSelectionChanged(String userId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedUserIds.add(userId);
      } else {
        _selectedUserIds.remove(userId);
      }});}
  void _onGenerateReportPressed() {
    if (_startDate == null || _endDate == null || _selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date range and at least one user.")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportResultPage(
          startDate: _startDate!,
          endDate: _endDate!,
          selectedUserIds: _selectedUserIds,
        ),),);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DateRangePickerWidget(
              startDate: _startDate,
              endDate: _endDate,
              onDateRangeSelected: _onDateRangeSelected,
            ),
            UserSelectionWidget(
              userNames: _userNames,
              selectedUserIds: _selectedUserIds,
              onUserSelectionChanged: _onUserSelectionChanged,
            ),
            ElevatedButton(
              onPressed: _onGenerateReportPressed,
              child: Text("Print Report"),
            ),],),),);}}
