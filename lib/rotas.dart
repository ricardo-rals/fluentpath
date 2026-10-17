import 'package:flutter/material.dart';

import 'screens/tela_agendar_aula.dart';
import 'screens/tela_boas_vindas.dart';
import 'screens/tela_contato.dart';
import 'screens/tela_contato_enviado.dart';
import 'screens/tela_detalhe_dica.dart';
import 'screens/tela_dicas.dart';
import 'screens/tela_inicial.dart';
import 'screens/tela_login.dart';
import 'screens/tela_minhas_aulas.dart';
import 'screens/tela_planos.dart';
import 'widgets/acesso_protegido.dart';

class Rotas {
  static const inicial = '/';

  static const dicas = '/dicas';

  static const detalheDica = '/dica';

  static const login = '/login';

  static const contato = '/contato';

  static const contatoEnviado = '/contato-enviado';

  static const minhasAulas = '/minhas-aulas';

  static const agendarAula = '/agendar-aula';

  static const boasVindas = '/inicio';

  static const planos = '/planos';

  static Map<String, WidgetBuilder> get mapa => {
        inicial: (_) => const TelaInicial(),
        dicas: (_) => const TelaDicas(),
        detalheDica: (_) => const TelaDetalheDica(),
        login: (_) => const TelaLogin(),
        contato: (_) => const TelaContato(),
        contatoEnviado: (_) => const TelaContatoEnviado(),
        boasVindas: (_) => const AcessoProtegido(
              titulo: 'Início',
              child: TelaBoasVindas(),
            ),
        minhasAulas: (_) => const AcessoProtegido(
              titulo: 'Minhas aulas',
              child: TelaMinhasAulas(),
            ),
        agendarAula: (_) => const AcessoProtegido(
              titulo: 'Agendar aula',
              child: TelaAgendarAula(),
            ),
        planos: (_) => const AcessoProtegido(
              titulo: 'Planos',
              child: TelaPlanos(),
            ),
      };
}
