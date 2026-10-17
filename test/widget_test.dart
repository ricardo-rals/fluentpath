import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluentpath/data/servico_dados.dart';
import 'package:fluentpath/main.dart';
import 'package:fluentpath/models/usuario.dart';
import 'package:fluentpath/widgets/acesso_protegido.dart';

// a leitura do asset e I/O real, fora do relogio falso do teste
Future<void> esperarTexto(WidgetTester tester, String texto) async {
  for (var i = 0; i < 20 && find.text(texto).evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 50)),
    );

    await tester.pump();
  }
}

Future<void> entrarComoAluno(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.login));

  await tester.pumpAndSettle();

  await tester.enterText(find.widgetWithText(TextField, 'Usuário'), 'aluno');

  await tester.enterText(find.widgetWithText(TextField, 'Senha'), '1234');

  await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

  await tester.pumpAndSettle();
}

Future<void> abrirMinhasAulas(WidgetTester tester) async {
  await tester.tap(find.text('Minhas aulas'));

  await tester.pumpAndSettle();

  await esperarTexto(tester, 'Gramática: Simple Past');
}

Future<void> esperarSnackBarSumir(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));

  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // cada teste le os assets do zero, sem reaproveitar leitura de outro teste
    rootBundle.clear();

    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App abre na tela de dicas pela rota inicial',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    expect(find.text('Dicas'), findsOneWidget);
  });

  testWidgets('Tela de dicas lista as dicas do JSON sem login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await esperarTexto(tester, 'Verb To Be');

    expect(find.text('Verb To Be'), findsOneWidget);

    expect(find.text('Simple Past'), findsOneWidget);
  });

  testWidgets('Tocar numa dica abre o detalhe com o conteudo dela',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await esperarTexto(tester, 'Verb To Be');

    await tester.tap(find.text('Simple Past'));

    await tester.pumpAndSettle();

    expect(find.text('Dica'), findsOneWidget);

    expect(find.text('Simple Past'), findsOneWidget);

    expect(find.textContaining('go → went'), findsOneWidget);
  });

  testWidgets('Deslogado, o botao Minhas aulas nao aparece',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    expect(find.text('Minhas aulas'), findsNothing);

    expect(find.byIcon(Icons.login), findsOneWidget);
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

    await esperarSnackBarSumir(tester);
  });

  testWidgets('Login com aluno / 1234 abre a pagina de boas-vindas',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await entrarComoAluno(tester);

    expect(find.text('Olá, aluno!'), findsOneWidget);

    expect(find.text('Dicas'), findsOneWidget);

    expect(find.text('Minhas aulas'), findsOneWidget);
  });

  testWidgets('Boas-vindas leva para as dicas, sem o botao Minhas aulas',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await entrarComoAluno(tester);

    await tester.tap(find.text('Dicas'));

    await tester.pumpAndSettle();

    await esperarTexto(tester, 'Verb To Be');

    expect(find.text('Verb To Be'), findsOneWidget);

    expect(find.text('Olá, aluno'), findsOneWidget);

    expect(find.text('Minhas aulas'), findsNothing);
  });

  testWidgets('Sair limpa a sessao e volta ao estado deslogado',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await entrarComoAluno(tester);

    await tester.tap(find.byTooltip('Sair'));

    await tester.pump();

    expect(find.text('Você saiu da sua conta'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Olá, aluno!'), findsNothing);

    expect(find.text('Minhas aulas'), findsNothing);

    expect(find.byIcon(Icons.login), findsOneWidget);

    await esperarSnackBarSumir(tester);
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

  testWidgets('Logado, o aluno ve as aulas e confirma presenca',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await entrarComoAluno(tester);

    await abrirMinhasAulas(tester);

    expect(find.text('Gramática: Simple Past'), findsOneWidget);

    expect(find.text('Confirmar presença'), findsNWidgets(2));

    await tester.tap(find.text('Confirmar presença').first);

    await tester.pump();

    expect(find.text('Confirmar presença'), findsOneWidget);

    await esperarSnackBarSumir(tester);
  });

  testWidgets('Cancelar uma aula pede confirmacao e tira da lista',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await entrarComoAluno(tester);

    await abrirMinhasAulas(tester);

    expect(find.text('Conversação: apresentações pessoais'), findsOneWidget);

    await tester.tap(find.text('Cancelar').first);

    await tester.pumpAndSettle();

    expect(find.text('Cancelar aula?'), findsOneWidget);

    await tester.tap(find.text('Cancelar aula'));

    await tester.pumpAndSettle();

    expect(find.text('Conversação: apresentações pessoais'), findsNothing);

    expect(find.text('Gramática: Simple Past'), findsOneWidget);

    await esperarSnackBarSumir(tester);
  });

  testWidgets('Agendar sem escolher tudo mostra aviso',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentPathApp());

    await entrarComoAluno(tester);

    await abrirMinhasAulas(tester);

    await tester.tap(find.text('Agendar aula'));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Conversação'));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Agendar'));

    await tester.pump();

    expect(find.text('Escolha o tema, o dia e o horário'), findsOneWidget);

    await esperarSnackBarSumir(tester);
  });
}
