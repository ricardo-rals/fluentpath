import 'package:flutter/material.dart';

import '../models/aula.dart';

String _doisDigitos(int numero) => numero.toString().padLeft(2, '0');

String formatarDia(DateTime data) {
  return '${_doisDigitos(data.day)}/${_doisDigitos(data.month)}/${data.year}';
}

String formatarData(DateTime data) {
  final horario = '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';

  return '${formatarDia(data)} às $horario';
}

class CardAula extends StatelessWidget {
  final Aula aula;

  final VoidCallback onConfirmar;

  final VoidCallback onCancelar;

  const CardAula({
    super.key,
    required this.aula,
    required this.onConfirmar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    final confirmada = aula.status == StatusAula.confirmada;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aula.titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: cores.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(formatarData(aula.data)),
              ],
            ),
            const SizedBox(height: 12),
            Chip(
              avatar: Icon(
                confirmada ? Icons.check_circle : Icons.event,
                size: 18,
                color: confirmada ? cores.primary : cores.secondary,
              ),
              label: Text(confirmada ? 'Presença confirmada' : 'Agendada'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancelar,
                  style: TextButton.styleFrom(foregroundColor: cores.error),
                  child: const Text('Cancelar'),
                ),
                if (!confirmada)
                  TextButton(
                    onPressed: onConfirmar,
                    child: const Text('Confirmar presença'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
