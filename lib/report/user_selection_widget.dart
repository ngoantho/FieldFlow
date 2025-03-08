import 'package:flutter/material.dart';

class UserSelectionWidget extends StatelessWidget {
  final Map<String, String> userNames;
  final List<String> selectedUserIds;
  final Function(String, bool) onUserSelectionChanged;

  UserSelectionWidget({
    required this.userNames,
    required this.selectedUserIds,
    required this.onUserSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: userNames.entries.map((entry) {
          return CheckboxListTile(
            title: Text(entry.value),
            value: selectedUserIds.contains(entry.key),
            onChanged: (bool? selected) {
              onUserSelectionChanged(entry.key, selected ?? false);
            },
          );
        }).toList(),
      ),
    );
  }
}
