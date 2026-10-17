import 'package:flutter/material.dart';

import '../models/dica.dart';
import '../widgets/conteudo_formatado.dart';

class TelaDetalheDica extends StatelessWidget {
  const TelaDetalheDica({super.key});

  @override
  Widget build(BuildContext context) {
    final dica = ModalRoute.of(context)!.settings.arguments as Dica;

    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dica')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      tema.colorScheme.primary.withValues(alpha: 0.12),
                  foregroundColor: tema.colorScheme.primary,
                  child: const Icon(Icons.lightbulb_outline),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    dica.titulo,
                    style: tema.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tema.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(left: 52),
              decoration: BoxDecoration(
                color: tema.colorScheme.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConteudoFormatado(texto: dica.conteudo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
