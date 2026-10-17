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

Future<void> esperarCarregar(WidgetTester tester) async {
  final carregando = find.byType(CircularProgressIndicator);

  for (var i = 0; i < 20 && carregando.evaluate().isNotEmpty; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 50)),
    );

    await tester.pump();
  }
}

// rola a tela ate o alvo quando ele ainda nao foi construido pela lista
Future<void> mostrar(WidgetTester tester, Finder alvo) async {
  if (alvo.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      alvo,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }

  await tester.ensureVisible(alvo);

  await tester.pumpAndSettle();
}

Future<void> tocar(WidgetTester tester, Finder alvo) async {
  await mostrar(tester, alvo);

  await tester.tap(alvo);

  await tester.pumpAndSettle();
}

Future<void> abrirApp(WidgetTester tester) async {
  await tester.pumpWidget(const FluentPathApp());

  await esperarCarregar(tester);
}

Future<void> abrirDicas(WidgetTester tester) async {
  await tocar(tester, find.text('Ver dicas grátis'));

  await esperarTexto(tester, 'Verb To Be');
}

Future<void> entrarComoAluno(WidgetTester tester) async {
  await tocar(tester, find.text('Já sou aluno? Entrar'));

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

  testWidgets('App abre na tela inicial com acoes e planos',
      (WidgetTester tester) async {
    await abrirApp(tester);

    expect(find.text('FluentPath'), findsOneWidget);

    expect(find.text('Quero ser aluno'), findsOneWidget);

    expect(find.text('Ver dicas grátis'), findsOneWidget);

    expect(find.text('Já sou aluno? Entrar'), findsOneWidget);

    for (final plano in ['Essencial', 'Intensivo', 'Fluente']) {
      await mostrar(tester, find.text(plano));

      expect(find.text(plano), findsOneWidget);
    }
  });

  testWidgets('Tela de dicas lista as dicas do JSON sem login',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await abrirDicas(tester);

    expect(find.text('Verb To Be'), findsOneWidget);

    expect(find.text('Simple Past'), findsOneWidget);

    expect(find.text('Minhas aulas'), findsNothing);
  });

  testWidgets('Tocar numa dica abre o detalhe com o conteudo dela',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await abrirDicas(tester);

    await tester.tap(find.text('Simple Past'));

    await tester.pumpAndSettle();

    expect(find.text('Dica'), findsOneWidget);

    expect(find.text('Simple Past'), findsOneWidget);

    expect(find.textContaining('go → went'), findsOneWidget);
  });

  testWidgets('Formulario de contato valida, envia e confirma',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await tocar(tester, find.text('Quero ser aluno'));

    await tocar(tester, find.widgetWithText(ElevatedButton, 'Enviar'));

    expect(find.text('Informe seu nome'), findsOneWidget);

    expect(find.text('Informe um e-mail válido'), findsOneWidget);

    expect(find.text('Informe um telefone com DDD'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome'),
      'Maria Souza',
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'maria@email.com',
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Telefone / WhatsApp'),
      '(71) 99999-9999',
    );

    await tocar(tester, find.widgetWithText(ElevatedButton, 'Enviar'));

    expect(find.text('Recebemos seu contato, Maria!'), findsOneWidget);

    await tocar(tester, find.text('Voltar ao início'));

    expect(find.text('Quero ser aluno'), findsOneWidget);
  });

  testWidgets('Tocar num plano abre o contato com o plano marcado',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await tocar(tester, find.text('Intensivo'));

    await esperarTexto(tester, 'Plano de interesse');

    await mostrar(tester, find.widgetWithText(ChoiceChip, 'Intensivo'));

    final chip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Intensivo'),
    );

    expect(chip.selected, isTrue);

    final outro = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Essencial'),
    );

    expect(outro.selected, isFalse);
  });

  testWidgets('Login com credencial errada mostra aviso',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await tocar(tester, find.text('Já sou aluno? Entrar'));

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
    await abrirApp(tester);

    await entrarComoAluno(tester);

    expect(find.text('Olá, aluno!'), findsOneWidget);

    expect(find.text('Dicas'), findsOneWidget);

    expect(find.text('Minhas aulas'), findsOneWidget);

    expect(find.text('Planos'), findsOneWidget);

    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('Logado, o aluno pede mudanca de plano e volta ao inicio dele',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await entrarComoAluno(tester);

    await tocar(tester, find.text('Planos'));

    await esperarCarregar(tester);

    expect(find.text('Seu plano'), findsOneWidget);

    expect(find.text('Mais escolhido'), findsNothing);

    await tocar(tester, find.text('Essencial'));

    expect(find.text('Mudar de plano'), findsNothing);

    await tocar(tester, find.text('Fluente'));

    expect(find.text('Mudar de plano'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome'),
      'Aluno Teste',
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'aluno@email.com',
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Telefone / WhatsApp'),
      '71999999999',
    );

    await tocar(tester, find.widgetWithText(ElevatedButton, 'Enviar'));

    expect(find.text('Recebemos seu contato, Aluno!'), findsOneWidget);

    await tocar(tester, find.text('Voltar ao início'));

    expect(find.text('Olá, aluno!'), findsOneWidget);
  });

  testWidgets('Boas-vindas leva para as dicas, sem o botao Minhas aulas',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await entrarComoAluno(tester);

    await tester.tap(find.text('Dicas'));

    await tester.pumpAndSettle();

    await esperarTexto(tester, 'Verb To Be');

    expect(find.text('Verb To Be'), findsOneWidget);

    expect(find.text('Olá, aluno'), findsOneWidget);

    expect(find.text('Minhas aulas'), findsNothing);
  });

  testWidgets('Sair limpa a sessao e volta para a tela inicial',
      (WidgetTester tester) async {
    await abrirApp(tester);

    await entrarComoAluno(tester);

    await tester.tap(find.byTooltip('Sair'));

    await tester.pump();

    expect(find.text('Você saiu da sua conta'), findsOneWidget);

    await esperarCarregar(tester);

    await tester.pumpAndSettle();

    expect(find.text('Olá, aluno!'), findsNothing);

    expect(find.text('Quero ser aluno'), findsOneWidget);

    expect(find.text('Já sou aluno? Entrar'), findsOneWidget);

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
    await abrirApp(tester);

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
    await abrirApp(tester);

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
    await abrirApp(tester);

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
