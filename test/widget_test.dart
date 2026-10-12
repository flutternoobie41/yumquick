import 'package:flutter_test/flutter_test.dart';
import 'package:yum_quick/app/app.dart';

void main() {
  testWidgets('app starts and shows the brand name', (tester) async {
    await tester.pumpWidget(const YumQUickApp());

    expect(find.text('YUMQUICK'), findsOneWidget);
  });
}
