import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_nepal/counter_widget.dart'; // Adjust the import path

void main() {
  testWidgets('Counter increments and decrements', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(home: CounterWidget()));

    // Verify the counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(Key('increment')));
    await tester.pump();

    // Verify the counter increments to 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // Tap the '-' icon and trigger a frame.
    await tester.tap(find.byKey(Key('decrement')));
    await tester.pump();

    // Verify the counter decrements back to 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
