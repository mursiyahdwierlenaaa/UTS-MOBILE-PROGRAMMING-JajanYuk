
import 'package:flutter_test/flutter_test.dart';
import 'package:jajan_yuk/main.dart';

void main() {
  testWidgets('JajanYuk app renders successfully', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const JajanYukApp());

    expect(find.byType(JajanYukApp), findsOneWidget);
  });
}
