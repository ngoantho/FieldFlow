import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets('basic functionality', (tester) async {
    await tester.pumpWidget(MaterialApp());
  });
}