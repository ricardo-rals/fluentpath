import 'package:flutter/material.dart';

import 'screens/tela_dicas.dart';

/// Nomes das rotas do app, num lugar so.
/// As telas das proximas atividades entram no mapa [Rotas.mapa]
/// conforme forem criadas.
class Rotas {
  static const dicas = '/';
  static const detalheDica = '/dica';
  static const login = '/login';
  static const minhasAulas = '/minhas-aulas';
  static const agendarAula = '/agendar-aula';

  static Map<String, WidgetBuilder> get mapa => {
        dicas: (_) => const TelaDicas(),
      };
}
