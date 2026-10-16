import 'package:flutter/material.dart';

/// Tela principal e publica, com a lista de dicas.
/// Por enquanto vazia: a lista vinda do servico entra na Atividade 5.
class TelaDicas extends StatelessWidget {
  const TelaDicas({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Dicas')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline, size: 64, color: cores.primary),
              const SizedBox(height: 16),
              Text(
                'Nenhuma dica por aqui ainda',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
