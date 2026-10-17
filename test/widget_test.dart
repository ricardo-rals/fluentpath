import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:fluentpath/data/servico_dados.dart';
import 'package:fluentpath/main.dart';
import 'package:fluentpath/models/usuario.dart';
import 'package:fluentpath/widgets/acesso_protegido.dart';

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

  testWidgets('Login com credencial errada mostra aviso',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await tester.tap(find.byIcon(Icons.login));

    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Usuário'), 'aluno');

    await tester.enterText(find.widgetWithText(TextField, 'Senha'), '0000');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

    await tester.pump();

    expect(find.text('Usuário ou senha inválidos'), findsOneWidget);

    expect(find.text('Área do aluno'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));

    await tester.pumpAndSettle();
  });

  testWidgets('Login com aluno / 1234 volta para as dicas logado',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await tester.tap(find.byIcon(Icons.login));

    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Usuário'), 'aluno');

    await tester.enterText(find.widgetWithText(TextField, 'Senha'), '1234');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

    await tester.pumpAndSettle();

    expect(find.text('Olá, aluno'), findsOneWidget);

    expect(find.byIcon(Icons.login), findsNothing);
  });

  testWidgets('Sair limpa a sessao e volta ao estado deslogado',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await tester.tap(find.byIcon(Icons.login));

    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Usuário'), 'aluno');

    await tester.enterText(find.widgetWithText(TextField, 'Senha'), '1234');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Sair'));

    await tester.pump();

    expect(find.text('Você saiu da sua conta'), findsOneWidget);

    expect(find.text('Olá, aluno'), findsNothing);

    expect(find.byIcon(Icons.login), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));

    await tester.pumpAndSettle();
  });

  testWidgets('Tela protegida bloqueia sem login e libera com login',
      (WidgetTester tester) async {
    final servico = ServicoDados();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: servico,
        child: const MaterialApp(
          home: AcessoProtegido(
            titulo: 'Minhas aulas',
            child: Text('Conteudo do aluno'),
          ),
        ),
      ),
    );

    expect(find.text('Esta área é só para alunos'), findsOneWidget);

    expect(find.text('Conteudo do aluno'), findsNothing);

    servico.login(const Usuario(nome: 'aluno'));

    await tester.pump();

    expect(find.text('Conteudo do aluno'), findsOneWidget);

    servico.logout();

    await tester.pump();

    expect(find.text('Esta área é só para alunos'), findsOneWidget);
  });
}
