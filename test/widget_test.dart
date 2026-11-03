import 'package:flutter_test/flutter_test.dart';
import 'package:sarpras_smk/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SarprasApp());
    expect(find.byType(SarprasApp), findsOneWidget);
  });
}
