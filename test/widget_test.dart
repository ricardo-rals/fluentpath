import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpath/main.dart';

// a leitura do asset e I/O real, fora do relogio falso do teste
Future<void> esperarDicas(WidgetTester tester) async {
  for (var i = 0; i < 20 && find.text('Verb To Be').evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 50)),
    );

    await tester.pump();
  }
}

void main() {
  // cada teste le os assets do zero, sem reaproveitar leitura de outro teste
  setUp(() => rootBundle.clear());

  testWidgets('App abre na tela de dicas pela rota inicial',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    expect(find.text('Dicas'), findsOneWidget);
  });

  testWidgets('Tela de dicas lista as dicas do JSON sem login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await esperarDicas(tester);

    expect(find.text('Verb To Be'), findsOneWidget);

    expect(find.text('Simple Past'), findsOneWidget);
  });

  testWidgets('Tocar numa dica abre o detalhe com o conteudo dela',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await esperarDicas(tester);

    await tester.tap(find.text('Simple Past'));

    await tester.pumpAndSettle();

    expect(find.text('Dica'), findsOneWidget);

    expect(find.text('Simple Past'), findsOneWidget);

    expect(find.textContaining('go → went'), findsOneWidget);
  });
}
