import 'package:flutter/material.dart';

import '../models/dica.dart';

class TelaDetalheDica extends StatelessWidget {
  const TelaDetalheDica({super.key});

  @override
  Widget build(BuildContext context) {
    final dica = ModalRoute.of(context)!.settings.arguments as Dica;

    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dica')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dica.titulo,
              style: tema.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: tema.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dica.conteudo,
              style: tema.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
