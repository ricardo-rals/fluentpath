import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/aula.dart';
import '../models/dica.dart';
import '../models/usuario.dart';

/// Ponto unico de acesso aos dados do app.
/// As telas pedem as listas aqui e nunca leem o JSON direto.
/// Tambem guarda em memoria o usuario logado e avisa as telas
/// quando a sessao muda.
class ServicoDados extends ChangeNotifier {
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
