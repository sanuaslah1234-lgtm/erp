import 'package:flutter_test/flutter_test.dart';
import 'package:erp_software/main.dart';

void main() {
  testWidgets('ERP App Auth & Employee module smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that Login Screen title is present initially
    expect(find.text('ERP Portal Login'), findsOneWidget);
  });
}
