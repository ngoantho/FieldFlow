import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:field_flow/report/user_selection_widget.dart';

void main() {
  testWidgets('UserSelectionWidget displays users and allows selection', (WidgetTester tester) async {
    final Map<String, String> mockUsers = {
      'user1': 'Q',
      'user2': 'Anthony',
      'user3': 'Test',
    };

    final List<String> selectedUsers = [];

    void onUserSelectionChanged(String userId, bool isSelected) {
      if (isSelected) {
        selectedUsers.add(userId);
      } else {
        selectedUsers.remove(userId);
      }
    }
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: UserSelectionWidget(
          userNames: mockUsers,
          selectedUserIds: selectedUsers,
          onUserSelectionChanged: onUserSelectionChanged,
        ),
      ),
    ));

    // Check if user names are displayed
    expect(find.text('Q'), findsOneWidget);
    expect(find.text('Anthony'), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);

    // Tap on Alice's checkbox
    await tester.tap(find.text('Q'));
    await tester.pumpAndSettle();

    // Verify Alice is selected
    expect(selectedUsers.contains('user1'), isTrue);

    // Tap on Alice's checkbox again (to deselect)
    await tester.tap(find.text('Q'));
    await tester.pumpAndSettle();

    // Verify Alice is deselected
    expect(selectedUsers.contains('Q'), isFalse);
  });
}
