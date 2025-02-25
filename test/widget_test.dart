import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_fit/main.dart';
import 'package:dr_fit/features/posts/data/repo_imp/comment_repo_imp.dart';
import 'package:dr_fit/features/posts/data/repo_imp/posts_repo_imp.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // إنشاء الـ Repositories
    final postsRepo = PostsRepoImp();
    final commentRepo = CommentRepoImp();

    // بناء التطبيق بتمرير الـ dependencies إذا كان MyApp يدعم ذلك
    await tester.pumpWidget(MyApp(
      postsRepo: postsRepo,
      commentRepo: commentRepo,
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
