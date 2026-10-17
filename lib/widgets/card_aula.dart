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
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    aula.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _Status(confirmada: confirmada),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: cores.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(formatarData(aula.data)),
              ],
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

class _Status extends StatelessWidget {
  final bool confirmada;

  const _Status({required this.confirmada});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    final cor = confirmada ? cores.primary : cores.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            confirmada ? Icons.check_circle : Icons.event,
            size: 16,
            color: cor,
          ),
          const SizedBox(width: 4),
          Text(
            confirmada ? 'Confirmada' : 'Agendada',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
