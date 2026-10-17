import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../models/plano.dart';
import '../rotas.dart';
import '../widgets/card_plano.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late final Future<List<Plano>> _planos;

  @override
  void initState() {
    super.initState();

    _planos = context.read<ServicoDados>().carregarPlanos();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    final logado = context.watch<ServicoDados>().logado;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _Cabecalho(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, Rotas.contato),
                  child: const Text('Quero ser aluno'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, Rotas.dicas),
                  child: const Text('Ver dicas grátis'),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    logado ? Rotas.boasVindas : Rotas.login,
                  ),
                  child: Text(
                    logado ? 'Ir para minha área' : 'Já sou aluno? Entrar',
                  ),
                ),
              ],
            ),
          ),
          const _Titulo(texto: 'Por que a FluentPath'),
          const _Diferencial(
            icone: Icons.record_voice_over_outlined,
            texto: 'Aulas ao vivo com professores',
          ),
          const _Diferencial(
            icone: Icons.event_available_outlined,
            texto: 'Agende e confirme suas aulas pelo app',
          ),
          const _Diferencial(
            icone: Icons.lightbulb_outline,
            texto: 'Dicas gratuitas de inglês toda semana',
          ),
          const SizedBox(height: 12),
          const _Titulo(texto: 'Nossos planos'),
          FutureBuilder<List<Plano>>(
            future: _planos,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Não foi possível carregar os planos',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Column(
                children: [
                  for (final plano in snapshot.data!)
                    CardPlano(
                      plano: plano,
                      onTap: () => Navigator.pushNamed(
                        context,
                        Rotas.contato,
                        arguments: plano.nome,
                      ),
                    ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Text(
              'Toque num plano para falar com a nossa equipe.',
              textAlign: TextAlign.center,
              style: tema.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
      decoration: BoxDecoration(
        color: tema.colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            child: const Icon(Icons.school, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'FluentPath',
            style: tema.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inglês no seu ritmo, com professores de verdade',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;

  const _Titulo({required this.texto});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        texto,
        style: tema.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: tema.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Diferencial extends StatelessWidget {
  final IconData icone;

  final String texto;

  const _Diferencial({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: cores.secondary.withValues(alpha: 0.2),
            foregroundColor: cores.primary,
            child: Icon(icone, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
