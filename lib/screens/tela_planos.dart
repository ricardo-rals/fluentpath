import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../models/plano.dart';
import '../rotas.dart';
import '../widgets/botao_sair.dart';
import '../widgets/card_plano.dart';

class TelaPlanos extends StatefulWidget {
  const TelaPlanos({super.key});

  @override
  State<TelaPlanos> createState() => _TelaPlanosState();
}

class _TelaPlanosState extends State<TelaPlanos> {
  late final Future<List<Plano>> _planos;

  @override
  void initState() {
    super.initState();

    _planos = context.read<ServicoDados>().carregarPlanos();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    final planoAtual = context.watch<ServicoDados>().usuario?.plano;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planos'),
        actions: const [BotaoSair()],
      ),
      body: FutureBuilder<List<Plano>>(
        future: _planos,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível carregar os planos'),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Quer mudar de plano? Toque no plano desejado e nossa '
                  'equipe entra em contato.',
                  style: tema.textTheme.bodyLarge,
                ),
              ),
              for (final plano in snapshot.data!)
                CardPlano(
                  plano: plano,
                  atual: plano.nome == planoAtual,
                  mostrarDestaque: false,
                  onTap: plano.nome == planoAtual
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            Rotas.contato,
                            arguments: plano.nome,
                          ),
                ),
            ],
          );
        },
      ),
    );
  }
}
