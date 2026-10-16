import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpath/main.dart';

void main() {
  testWidgets('App abre na tela de dicas pela rota inicial',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());
    expect(find.text('Dicas'), findsOneWidget);
  });
}
