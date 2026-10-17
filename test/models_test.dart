import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpath/models/aula.dart';
import 'package:fluentpath/models/dica.dart';
import 'package:fluentpath/models/plano.dart';
import 'package:fluentpath/models/usuario.dart';

void main() {
  test('Dica.fromJson le titulo e conteudo', () {
    final dica = Dica.fromJson({
      'titulo': 'Verb To Be',
      'conteudo': 'I am, you are, he is.',
    });

    expect(dica.titulo, 'Verb To Be');

    expect(dica.conteudo, 'I am, you are, he is.');
  });

  test('Aula.fromJson le titulo, data e status', () {
    final aula = Aula.fromJson({
      'titulo': 'Conversacao',
      'data': '2026-10-20T14:00:00',
      'status': 'confirmada',
    });

    expect(aula.titulo, 'Conversacao');

    expect(aula.data, DateTime(2026, 10, 20, 14));

    expect(aula.status, StatusAula.confirmada);
  });

  test('Aula.toJson e o inverso de Aula.fromJson', () {
    final original =
        Aula(titulo: 'Listening', data: DateTime(2026, 10, 27, 16, 30));

    final copia = Aula.fromJson(original.toJson());

    expect(copia.titulo, original.titulo);

    expect(copia.data, original.data);

    expect(copia.status, original.status);
  });

  test('Usuario.fromJson le nome', () {
    expect(Usuario.fromJson({'nome': 'aluno'}).nome, 'aluno');
  });

  test('Plano.fromJson le os campos e formata o preco', () {
    final plano = Plano.fromJson({
      'nome': 'Intensivo',
      'aulasPorSemana': 2,
      'preco': 259,
      'descricao': 'O mais escolhido',
      'destaque': true,
    });

    expect(plano.nome, 'Intensivo');

    expect(plano.aulasPorSemana, 2);

    expect(plano.destaque, isTrue);

    expect(plano.precoFormatado, r'R$ 259,00/mês');
  });
}
