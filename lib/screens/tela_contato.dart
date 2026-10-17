import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../models/contato.dart';
import '../models/plano.dart';
import '../rotas.dart';

String? validarNome(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe seu nome';
  }

  return null;
}

String? validarEmail(String? valor) {
  final email = valor?.trim() ?? '';

  if (!email.contains('@') || !email.contains('.')) {
    return 'Informe um e-mail válido';
  }

  return null;
}

String? validarTelefone(String? valor) {
  final digitos = (valor ?? '').replaceAll(RegExp(r'\D'), '');

  if (digitos.length < 10) {
    return 'Informe um telefone com DDD';
  }

  return null;
}

class TelaContato extends StatefulWidget {
  const TelaContato({super.key});

  @override
  State<TelaContato> createState() => _TelaContatoState();
}

class _TelaContatoState extends State<TelaContato> {
  final _formulario = GlobalKey<FormState>();

  final _nome = TextEditingController();

  final _email = TextEditingController();

  final _telefone = TextEditingController();

  final _mensagem = TextEditingController();

  late final Future<List<Plano>> _planos;

  String? _plano;

  bool _planoInicialLido = false;

  @override
  void initState() {
    super.initState();

    _planos = context.read<ServicoDados>().carregarPlanos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_planoInicialLido) {
      _plano = ModalRoute.of(context)?.settings.arguments as String?;

      _planoInicialLido = true;
    }
  }

  @override
  void dispose() {
    _nome.dispose();

    _email.dispose();

    _telefone.dispose();

    _mensagem.dispose();

    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formulario.currentState!.validate()) {
      return;
    }

    final navegador = Navigator.of(context);

    final nome = _nome.text.trim();

    final mensagem = _mensagem.text.trim();

    await context.read<ServicoDados>().enviarContato(
          Contato(
            nome: nome,
            email: _email.text.trim(),
            telefone: _telefone.text.trim(),
            plano: _plano,
            mensagem: mensagem.isEmpty ? null : mensagem,
          ),
        );

    navegador.pushReplacementNamed(Rotas.contatoEnviado, arguments: nome);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    final logado = context.watch<ServicoDados>().logado;

    return Scaffold(
      appBar: AppBar(
        title: Text(logado ? 'Mudar de plano' : 'Quero ser aluno'),
      ),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              logado
                  ? 'Confirme seus dados e nossa equipe entra em contato para '
                      'mudar o seu plano.'
                  : 'Deixe seus dados e nossa equipe entra em contato para '
                      'montar o seu plano.',
              style: tema.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nome,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: validarNome,
              decoration: const InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: validarEmail,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefone,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              validator: validarTelefone,
              decoration: const InputDecoration(
                labelText: 'Telefone / WhatsApp',
                hintText: '(71) 99999-9999',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 24),
            Text('Plano de interesse', style: tema.textTheme.titleMedium),
            const SizedBox(height: 12),
            FutureBuilder<List<Plano>>(
              future: _planos,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final plano in snapshot.data!)
                      ChoiceChip(
                        label: Text(plano.nome),
                        selected: _plano == plano.nome,
                        onSelected: (selecionado) => setState(
                          () => _plano = selecionado ? plano.nome : null,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _mensagem,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Mensagem (opcional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _enviar,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
