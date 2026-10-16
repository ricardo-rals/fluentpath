import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpath/data/servico_dados.dart';
import 'package:fluentpath/models/usuario.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final servico = ServicoDados();

  test('servico carrega as dicas do JSON', () async {
    final dicas = await servico.carregarDicas();
    expect(dicas, isNotEmpty);
    expect(dicas.first.titulo, 'Verb To Be');
  });

  test('servico carrega as aulas do JSON', () async {
    expect(await servico.carregarAulas(), isNotEmpty);
  });

  test('servico guarda e limpa o usuario da sessao', () {
    expect(servico.logado, isFalse);
    servico.login(const Usuario(nome: 'aluno'));
    expect(servico.usuario?.nome, 'aluno');
    servico.logout();
    expect(servico.logado, isFalse);
  });
}
