import 'package:flutter_test/flutter_test.dart';

import 'package:promessas/my_app.dart';

void main() {
  testWidgets('renders app title and button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Caixinha de Promessas'), findsOneWidget);
    expect(find.text('Sortear promessa'), findsOneWidget);
  });
}
