import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/aula.dart';
import '../models/dica.dart';
import '../models/usuario.dart';

class ServicoDados extends ChangeNotifier {
  static const _usuarioValido = 'aluno';

  static const _senhaValida = '1234';

  static const _chaveAulas = 'aulas';

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  bool get logado => _usuario != null;

  List<Aula>? _aulas;

  List<Aula> get aulas => List.unmodifiable(_aulas ?? []);

  Future<List<Dica>> carregarDicas() async {
    final lista = await _lerLista('assets/data/dicas.json');

    return lista.map((json) => Dica.fromJson(json)).toList();
  }

  Future<List<Aula>> carregarAulas() async {
    if (_aulas == null) {
      final salvas = await _lerAulasSalvas();

      final lista = salvas != null
          ? (jsonDecode(salvas) as List).cast<Map<String, dynamic>>()
          : await _lerLista('assets/data/aulas.json');

      _aulas = lista.map((json) => Aula.fromJson(json)).toList();

      _ordenarAulas();
    }

    return aulas;
  }

  Future<void> agendarAula(String titulo, DateTime data) async {
    await carregarAulas();

    _aulas!.add(Aula(titulo: titulo, data: data));

    _ordenarAulas();

    await _salvarAulas();

    notifyListeners();
  }

  Future<void> confirmarPresenca(Aula aula) async {
    aula.status = StatusAula.confirmada;

    await _salvarAulas();

    notifyListeners();
  }

  Future<void> cancelarAula(Aula aula) async {
    _aulas!.remove(aula);

    await _salvarAulas();

    notifyListeners();
  }

  void _ordenarAulas() {
    _aulas!.sort((a, b) => a.data.compareTo(b.data));
  }

  Future<String?> _lerAulasSalvas() async {
    try {
      final preferencias = await SharedPreferences.getInstance();

      return preferencias.getString(_chaveAulas);
    } catch (erro) {
      debugPrint('Nao foi possivel ler as aulas salvas: $erro');

      return null;
    }
  }

  Future<void> _salvarAulas() async {
    final json = jsonEncode(_aulas!.map((aula) => aula.toJson()).toList());

    try {
      final preferencias = await SharedPreferences.getInstance();

      await preferencias.setString(_chaveAulas, json);
    } catch (erro) {
      debugPrint('Nao foi possivel salvar as aulas: $erro');
    }
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
