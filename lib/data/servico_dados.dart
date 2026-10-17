import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/aula.dart';
import '../models/dica.dart';
import '../models/usuario.dart';

class ServicoDados extends ChangeNotifier {
  static const _usuarioValido = 'aluno';

  static const _senhaValida = '1234';

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  bool get logado => _usuario != null;

  Future<List<Dica>> carregarDicas() async {
    final lista = await _lerLista('assets/data/dicas.json');

    return lista.map((json) => Dica.fromJson(json)).toList();
  }

  Future<List<Aula>> carregarAulas() async {
    final lista = await _lerLista('assets/data/aulas.json');

    return lista.map((json) => Aula.fromJson(json)).toList();
  }

  bool autenticar(String usuario, String senha) {
    if (usuario != _usuarioValido || senha != _senhaValida) {
      return false;
    }

    login(Usuario(nome: usuario));

    return true;
  }

  void login(Usuario usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void logout() {
    _usuario = null;

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _lerLista(String caminho) async {
    final conteudo = await rootBundle.loadString(caminho);

    return (jsonDecode(conteudo) as List).cast<Map<String, dynamic>>();
  }
}
