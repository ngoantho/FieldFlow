import 'package:field_flow/db/firestore_helper.dart';
import 'package:field_flow/homepage.dart';
import 'package:field_flow/providers/position_provider.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import 'homepage_test.mocks.dart';

@GenerateMocks([FirestoreHelper])
void main() {
  testWidgets('Homepage shows check in/out button', (tester) async {
    final firestoreHelper = MockFirestoreHelper();
    final timeTracker = TimeTracker(firestoreHelper: firestoreHelper);
    final positionProvider = PositionProvider();

    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider<TimeTracker>.value(value: timeTracker),
      ChangeNotifierProvider<PositionProvider>.value(value: positionProvider)
    ], child: MaterialApp(home: Homepage())));
  });
}
