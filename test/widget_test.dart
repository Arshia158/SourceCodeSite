import 'package:flutter_test/flutter_test.dart';
import 'package:source_code_site/main.dart';

void main() {
  testWidgets('home page renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SourceCodeSiteApp());

    expect(find.text('سورس کد سایت'), findsWidgets);
    expect(find.text('دریافت'), findsOneWidget);
    expect(find.text('کپی کد'), findsOneWidget);
    expect(find.text('ذخیره'), findsOneWidget);
    expect(find.text('اشتراک'), findsOneWidget);
  });
}
