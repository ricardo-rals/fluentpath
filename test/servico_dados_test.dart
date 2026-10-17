import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluentpath/data/servico_dados.dart';
import 'package:fluentpath/models/aula.dart';
import 'package:fluentpath/models/contato.dart';
import 'package:fluentpath/models/usuario.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ServicoDados servico;

  setUp(() {
    rootBundle.clear();

    SharedPreferences.setMockInitialValues({});

    servico = ServicoDados();
  });

  test('servico carrega as dicas do JSON', () async {
    final dicas = await servico.carregarDicas();

    expect(dicas, isNotEmpty);

    expect(dicas.first.titulo, 'Verb To Be');
  });

  test('servico carrega as aulas do JSON', () async {
    expect(await servico.carregarAulas(), hasLength(3));
  });

  test('servico carrega os planos do JSON', () async {
    final planos = await servico.carregarPlanos();

    expect(planos.map((plano) => plano.nome),
        ['Essencial', 'Intensivo', 'Fluente']);

    expect(planos.where((plano) => plano.destaque), hasLength(1));
  });

  test('servico guarda o contato enviado', () async {
    await servico.enviarContato(
      const Contato(
        nome: 'Maria',
        email: 'maria@email.com',
        telefone: '71999999999',
        plano: 'Intensivo',
      ),
    );

    expect(servico.contatos, hasLength(1));

    expect(servico.contatos.first.plano, 'Intensivo');
  });

  test('servico guarda e limpa o usuario da sessao', () {
    expect(servico.logado, isFalse);

    servico.login(const Usuario(nome: 'aluno'));

    expect(servico.usuario?.nome, 'aluno');

    servico.logout();

    expect(servico.logado, isFalse);
  });

  test('servico aceita so a credencial aluno / 1234', () {
    expect(servico.autenticar('aluno', 'errada'), isFalse);

    expect(servico.autenticar('outro', '1234'), isFalse);

    expect(servico.logado, isFalse);

    expect(servico.autenticar('aluno', '1234'), isTrue);

    expect(servico.usuario?.nome, 'aluno');
  });

  test('servico agenda aula em ordem de data e confirma presenca', () async {
    final antes = (await servico.carregarAulas()).length;

    await servico.agendarAula('Pronúncia', DateTime(2026, 10, 18, 9));

    final aulas = servico.aulas;

    expect(aulas.length, antes + 1);

    expect(aulas.first.titulo, 'Pronúncia');

    expect(aulas.first.status, StatusAula.agendada);

    await servico.confirmarPresenca(aulas.first);

    expect(servico.aulas.first.status, StatusAula.confirmada);
  });

  test('servico cancela aula e tira da lista', () async {
    final aulas = await servico.carregarAulas();

    final cancelada = aulas.first;

    await servico.cancelarAula(cancelada);

    expect(servico.aulas, hasLength(aulas.length - 1));

    expect(servico.aulas, isNot(contains(cancelada)));
  });

  test('aulas continuam salvas depois de sair e ao reabrir o app', () async {
    servico.login(const Usuario(nome: 'aluno'));

    await servico.agendarAula('Pronúncia', DateTime(2026, 10, 18, 9));

    await servico.cancelarAula(servico.aulas.last);

    servico.logout();

    expect(servico.aulas, hasLength(3));

    final reaberto = ServicoDados();

    final aulas = await reaberto.carregarAulas();

    expect(aulas, hasLength(3));

    expect(aulas.first.titulo, 'Pronúncia');

    expect(aulas.any((aula) => aula.titulo.startsWith('Listening')), isFalse);
  });
}
