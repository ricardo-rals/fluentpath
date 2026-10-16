import 'package:flutter/material.dart';

import 'screens/tela_detalhe_dica.dart';
import 'screens/tela_dicas.dart';

class Rotas {
  static const dicas = '/';

  static const detalheDica = '/dica';

  static const login = '/login';

  static const minhasAulas = '/minhas-aulas';

  static const agendarAula = '/agendar-aula';

  static Map<String, WidgetBuilder> get mapa => {
        dicas: (_) => const TelaDicas(),
        detalheDica: (_) => const TelaDetalheDica(),
      };
}
