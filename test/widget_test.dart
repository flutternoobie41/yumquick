import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/app/app.dart';

void main() {
  testWidgets('app starts and shows the brand name', (tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());

    expect(find.text('YUMQUICK'), findsOneWidget);
  });
}
