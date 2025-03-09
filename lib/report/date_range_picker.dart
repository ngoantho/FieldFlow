import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime, DateTime) onDateRangeSelected;

  const DateRangePickerWidget({super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateRangeSelected,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (pickedRange != null) {
      onDateRangeSelected(pickedRange.start, pickedRange.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(startDate == null
          ? "Select Date Range"
          : "From ${DateFormat.yMMMd().format(startDate!)} to ${DateFormat.yMMMd().format(endDate!)}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () => _pickDateRange(context),
    );
  }
}
