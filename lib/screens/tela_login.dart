import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../rotas.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _usuario = TextEditingController();

  final _senha = TextEditingController();

  bool _senhaVisivel = false;

  @override
  void dispose() {
    _usuario.dispose();

    _senha.dispose();

    super.dispose();
  }

  void _entrar() {
    final servico = context.read<ServicoDados>();

    final autenticado = servico.autenticar(_usuario.text.trim(), _senha.text);

    if (!autenticado) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos')),
        );

      return;
    }

    Navigator.pushReplacementNamed(context, Rotas.boasVindas);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.school_outlined, size: 72, color: tema.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            'Área do aluno',
            style: tema.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _usuario,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Usuário',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _senha,
            obscureText: !_senhaVisivel,
            onSubmitted: (_) => _entrar(),
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _entrar,
            child: const Text('Entrar'),
          ),
          const SizedBox(height: 16),
          Text(
            'Acesso de demonstração: aluno / 1234',
            style: tema.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
