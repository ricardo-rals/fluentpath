import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../models/aula.dart';
import '../rotas.dart';
import '../widgets/botao_sair.dart';
import '../widgets/card_aula.dart';

class TelaMinhasAulas extends StatefulWidget {
  const TelaMinhasAulas({super.key});

  @override
  State<TelaMinhasAulas> createState() => _TelaMinhasAulasState();
}

class _TelaMinhasAulasState extends State<TelaMinhasAulas> {
  late final Future<List<Aula>> _carregamento;

  @override
  void initState() {
    super.initState();

    _carregamento = context.read<ServicoDados>().carregarAulas();
  }

  Future<void> _confirmar(Aula aula) async {
    final mensageiro = ScaffoldMessenger.of(context);

    await context.read<ServicoDados>().confirmarPresenca(aula);

    mensageiro
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Presença confirmada')),
      );
  }

  Future<void> _cancelar(Aula aula) async {
    final servico = context.read<ServicoDados>();

    final mensageiro = ScaffoldMessenger.of(context);

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Cancelar aula?'),
        content: Text(aula.titulo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Cancelar aula'),
          ),
        ],
      ),
    );

    if (confirmou != true) {
      return;
    }

    await servico.cancelarAula(aula);

    mensageiro
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Aula cancelada')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas aulas'),
        actions: const [BotaoSair()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, Rotas.agendarAula),
        icon: const Icon(Icons.add),
        label: const Text('Agendar aula'),
      ),
      body: FutureBuilder<List<Aula>>(
        future: _carregamento,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível carregar suas aulas'),
            );
          }

          final aulas = context.watch<ServicoDados>().aulas;

          if (aulas.isEmpty) {
            return const Center(
              child: Text('Você ainda não tem aulas marcadas'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 88),
            itemCount: aulas.length,
            itemBuilder: (context, i) => CardAula(
              aula: aulas[i],
              onConfirmar: () => _confirmar(aulas[i]),
              onCancelar: () => _cancelar(aulas[i]),
            ),
          );
        },
      ),
    );
  }
}
