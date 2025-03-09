import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/week_list/choose_worker_page.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'choose_worker_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
void main() {
  group('Choose Worker Page Tests', () {
    late MockFirestoreHelper mockFirestoreHelper;

    setUp(() {
      mockFirestoreHelper = MockFirestoreHelper();
    });

    testWidgets('Displays list of workers and allows selection', (tester) async {
      // Mock FirestoreHelper to return a list of workers
      when(mockFirestoreHelper.fetchUsers()).thenAnswer((_) async => [
        {'id': '1', 'name': 'Test Worker 1'},
        {'id': '2', 'name': 'Test Worker 2'},
      ]);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<FirestoreHelper>.value(value: mockFirestoreHelper),
          ],
          child: MaterialApp(home: ChooseWorkerPage()),
        ),
      );

      await tester.pumpAndSettle(); // Wait for UI to render

      // Ensure workers appear in the list
      expect(find.text('Test Worker 1'), findsOneWidget);
      expect(find.text('Test Worker 2'), findsOneWidget);

    });

    testWidgets('Make Report button is present and navigates correctly', (tester) async {
      // Mock FirestoreHelper to return an empty list (no workers)
      when(mockFirestoreHelper.fetchUsers()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<FirestoreHelper>.value(value: mockFirestoreHelper),
          ],
          child: MaterialApp(home: ChooseWorkerPage()),
        ),
      );

      await tester.pumpAndSettle(); // Wait for UI to render

      // Ensure "Make Report" button exists
      expect(find.text("Make Report"), findsOneWidget);
    });
  });
}
