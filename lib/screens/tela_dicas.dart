import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../models/dica.dart';
import '../rotas.dart';
import '../widgets/card_dica.dart';

class TelaDicas extends StatefulWidget {
  const TelaDicas({super.key});

  @override
  State<TelaDicas> createState() => _TelaDicasState();
}

class _TelaDicasState extends State<TelaDicas> {
  late final Future<List<Dica>> _dicas;

  @override
  void initState() {
    super.initState();

    _dicas = context.read<ServicoDados>().carregarDicas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dicas')),
      body: FutureBuilder<List<Dica>>(
        future: _dicas,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const _Aviso(
              icone: Icons.error_outline,
              texto: 'Nao foi possivel carregar as dicas',
            );
          }

          final dicas = snapshot.data!;

          if (dicas.isEmpty) {
            return const _Aviso(
              icone: Icons.lightbulb_outline,
              texto: 'Nenhuma dica por aqui ainda',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: dicas.length,
            itemBuilder: (context, i) => CardDica(
              dica: dicas[i],
              onTap: () => Navigator.pushNamed(
                context,
                Rotas.detalheDica,
                arguments: dicas[i],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  final IconData icone;

  final String texto;

  const _Aviso({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              texto,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
