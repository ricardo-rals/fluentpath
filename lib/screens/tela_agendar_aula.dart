import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/servico_dados.dart';
import '../widgets/botao_sair.dart';
import '../widgets/card_aula.dart';

class TelaAgendarAula extends StatefulWidget {
  const TelaAgendarAula({super.key});

  @override
  State<TelaAgendarAula> createState() => _TelaAgendarAulaState();
}

class _TelaAgendarAulaState extends State<TelaAgendarAula> {
  static const _temas = [
    'Conversação',
    'Gramática',
    'Listening',
    'Vocabulário',
    'Pronúncia',
  ];

  String? _tema;

  DateTime? _dia;

  TimeOfDay? _horario;

  DateTime? get _dataCompleta {
    if (_dia == null || _horario == null) {
      return null;
    }

    return DateTime(
      _dia!.year,
      _dia!.month,
      _dia!.day,
      _horario!.hour,
      _horario!.minute,
    );
  }

  Future<void> _escolherDia() async {
    final hoje = DateTime.now();

    final escolhido = await showDatePicker(
      context: context,
      initialDate: _dia ?? hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 90)),
    );

    if (escolhido != null) {
      setState(() => _dia = escolhido);
    }
  }

  Future<void> _escolherHorario() async {
    final escolhido = await showTimePicker(
      context: context,
      initialTime: _horario ?? const TimeOfDay(hour: 14, minute: 0),
    );

    if (escolhido != null) {
      setState(() => _horario = escolhido);
    }
  }

  Future<void> _agendar() async {
    final data = _dataCompleta;

    final mensageiro = ScaffoldMessenger.of(context);

    if (_tema == null || data == null) {
      mensageiro
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Escolha o tema, o dia e o horário')),
        );

      return;
    }

    final navegador = Navigator.of(context);

    await context.read<ServicoDados>().agendarAula(_tema!, data);

    navegador.pop();

    mensageiro
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Aula agendada')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    final data = _dataCompleta;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar aula'),
        actions: const [BotaoSair()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Tema da aula', style: tema.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final opcao in _temas)
                ChoiceChip(
                  label: Text(opcao),
                  selected: _tema == opcao,
                  onSelected: (_) => setState(() => _tema = opcao),
                ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Quando', style: tema.textTheme.titleMedium),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _escolherDia,
            icon: const Icon(Icons.calendar_today),
            label: Text(_dia == null ? 'Escolher dia' : formatarDia(_dia!)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _escolherHorario,
            icon: const Icon(Icons.access_time),
            label: Text(
              _horario == null ? 'Escolher horário' : _horario!.format(context),
            ),
          ),
          if (data != null) ...[
            const SizedBox(height: 20),
            Text(
              'Sua aula será em ${formatarData(data)}',
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _agendar,
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }
}
