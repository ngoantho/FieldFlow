import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/model/week_model.dart';
import 'package:field_flow/week_list/choose_worker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'choose_worker_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
void main() {
  group('Choose Worker page', () {
    testWidgets('Worker 1 brings up the worker page', (tester) async {
      final firestoreHelper = MockFirestoreHelper();
      when(firestoreHelper.getWeeksStream(userId: '1')).thenAnswer(
        (realInvocation) {
          return Stream.value(<WeekModel>[]);
        },
      );

      await tester.pumpWidget(MultiProvider(providers: [
        Provider<FirestoreHelper>.value(value: firestoreHelper),
      ], child: MaterialApp(home: ChooseWorkerPage())));

      final worker1 = find.text('1');
      expect(worker1, findsOne);

      await tester.tap(worker1);
      await tester.pumpAndSettle();

      final worker1Page = find.text('Worker (ID: 1)');
      expect(worker1Page, findsOne);
    });
  });
}
