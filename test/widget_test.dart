import 'package:flutter_test/flutter_test.dart';
import 'package:groupproject_group5/app/app.dart';

void main() {
  testWidgets('App shows welcome screen when logged out', (WidgetTester tester) async {
    await tester.pumpWidget(const FocusWellbeingApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Build your city'), findsOneWidget);
  });
}
