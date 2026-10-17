import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../rotas.dart';

class BotaoSair extends StatelessWidget {
  const BotaoSair({super.key});

  void _sair(BuildContext context) {
    final mensageiro = ScaffoldMessenger.of(context);

    context.read<ServicoDados>().logout();

    Navigator.pushNamedAndRemoveUntil(context, Rotas.dicas, (_) => false);

    mensageiro
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Você saiu da sua conta')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Sair',
      onPressed: () => _sair(context),
    );
  }
}
