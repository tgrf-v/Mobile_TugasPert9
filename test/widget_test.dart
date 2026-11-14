import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tugas_pert9/main.dart';

void main() {
  testWidgets('MahasiswaPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MahasiswaPage()));
    expect(find.byType(MahasiswaPage), findsOneWidget);
  });
}
