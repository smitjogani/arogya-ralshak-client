// This is a basic Flutter widget test.
//

import 'package:flutter_test/flutter_test.dart';

import 'package:aarogya_rakshak/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AarogyaRakshakApp());
    expect(find.text('Aarogya-Rakshak'), findsWidgets);
  });
}
