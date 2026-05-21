import 'package:flutter_test/flutter_test.dart';

import 'package:fugainfo/main.dart';

void main() {
  testWidgets('FarmaFind login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FarmaFindApp());

    // Verify that the login screen is displayed.
    expect(find.text('FarmaFind'), findsWidgets);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
  });
}
