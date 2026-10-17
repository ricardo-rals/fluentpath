import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../rotas.dart';

class TelaContatoEnviado extends StatelessWidget {
  const TelaContatoEnviado({super.key});

  @override
  Widget build(BuildContext context) {
    final nome = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    final primeiroNome = nome.split(' ').first;

    final tema = Theme.of(context);

    final logado = context.read<ServicoDados>().logado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato enviado'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle,
                  size: 88, color: tema.colorScheme.primary),
              const SizedBox(height: 20),
              Text(
                'Recebemos seu contato, $primeiroNome!',
                textAlign: TextAlign.center,
                style: tema.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nossa equipe vai falar com você em até 24 horas pelo '
                'telefone ou e-mail informado.',
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(
                  context,
                  ModalRoute.withName(
                      logado ? Rotas.boasVindas : Rotas.inicial),
                ),
                child: const Text('Voltar ao início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
