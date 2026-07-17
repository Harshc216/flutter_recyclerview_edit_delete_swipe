import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Tasks screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SwipeDemoApp());

    // Verify that the title 'Swipeable Tasks' is shown.
    expect(find.text('Swipeable Tasks'), findsOneWidget);
    
    // Verify that the initial tasks are rendered.
    expect(find.text('Design app landing page'), findsOneWidget);
  });
}
