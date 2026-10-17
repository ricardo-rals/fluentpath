import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../rotas.dart';
import '../widgets/botao_sair.dart';

class TelaBoasVindas extends StatelessWidget {
  const TelaBoasVindas({super.key});

  @override
  Widget build(BuildContext context) {
    final nome = context.watch<ServicoDados>().usuario?.nome ?? '';

    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: const [BotaoSair()],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, $nome!',
                  style: tema.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tema.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'O que você quer fazer hoje?',
                  style: tema.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _Atalho(
            icone: Icons.lightbulb_outline,
            titulo: 'Dicas',
            descricao: 'Leia dicas de gramática e vocabulário',
            onTap: () => Navigator.pushNamed(context, Rotas.dicas),
          ),
          _Atalho(
            icone: Icons.event_note,
            titulo: 'Minhas aulas',
            descricao: 'Veja, agende e confirme suas aulas',
            onTap: () => Navigator.pushNamed(context, Rotas.minhasAulas),
          ),
        ],
      ),
    );
  }
}

class _Atalho extends StatelessWidget {
  final IconData icone;

  final String titulo;

  final String descricao;

  final VoidCallback onTap;

  const _Atalho({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: cores.primary.withValues(alpha: 0.12),
                foregroundColor: cores.primary,
                child: Icon(icone, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(descricao),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
