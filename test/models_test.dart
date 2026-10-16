import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpath/models/aula.dart';
import 'package:fluentpath/models/dica.dart';
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

  test('Usuario.fromJson le nome', () {
    expect(Usuario.fromJson({'nome': 'aluno'}).nome, 'aluno');
  });
}
