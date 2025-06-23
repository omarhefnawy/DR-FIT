
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_fit/main.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // إنشاء الـ Repositories

    // بناء التطبيق بتمرير الـ dependencies إذا كان MyApp يدعم ذلك
    await tester.pumpWidget(MyApp(

    ));

    // انتظار تحميل جميع العناصر
    await tester.pumpAndSettle();

    // التأكد أن العداد يبدأ من 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // الضغط على زر + وزيادة العداد
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // التحقق من أن العداد أصبح 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
