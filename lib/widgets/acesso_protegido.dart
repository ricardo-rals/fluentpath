import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../rotas.dart';

class AcessoProtegido extends StatelessWidget {
  final String titulo;

  final Widget child;

  const AcessoProtegido({super.key, required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    final logado = context.watch<ServicoDados>().logado;

    if (logado) {
      return child;
    }

    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 64, color: tema.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Esta área é só para alunos',
                style: tema.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Entre com sua conta para continuar.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, Rotas.login),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
