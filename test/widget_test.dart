import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beautician/main.dart';

void main() {
  testWidgets('App initializes successfully with responsive shell', (WidgetTester tester) async {
    // Set a desktop surface size
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const BeauticianApp());
    await tester.pumpAndSettle();

    // Verify app renders with the route placeholder or title
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
