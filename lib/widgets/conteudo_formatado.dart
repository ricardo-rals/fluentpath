import 'package:flutter/material.dart';

// Marcacao aceita no conteudo das dicas:
// **texto** negrito, __texto__ sublinhado,
// "# " no inicio da linha vira titulo de secao e "- " vira item de lista.
final _marcacao = RegExp(r'\*\*(.+?)\*\*|__(.+?)__');

String textoSimples(String texto) {
  return texto
      .replaceAll('**', '')
      .replaceAll('__', '')
      .split('\n')
      .map((linha) => linha.replaceFirst(RegExp(r'^(# |- )'), '').trim())
      .where((linha) => linha.isNotEmpty)
      .join(' ');
}

class ConteudoFormatado extends StatelessWidget {
  final String texto;

  const ConteudoFormatado({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    final linhas = texto.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final linha in linhas) _bloco(context, linha),
      ],
    );
  }

  Widget _bloco(BuildContext context, String linha) {
    final tema = Theme.of(context);

    final estiloBase = tema.textTheme.bodyLarge?.copyWith(height: 1.5);

    if (linha.trim().isEmpty) {
      return const SizedBox(height: 12);
    }

    if (linha.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(
          linha.substring(2),
          style: tema.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: tema.colorScheme.primary,
          ),
        ),
      );
    }

    if (linha.startsWith('- ')) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: tema.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                _trechos(context, linha.substring(2)),
                style: estiloBase,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(_trechos(context, linha), style: estiloBase),
    );
  }

  TextSpan _trechos(BuildContext context, String linha) {
    final cores = Theme.of(context).colorScheme;

    final trechos = <TextSpan>[];

    var inicio = 0;

    for (final marca in _marcacao.allMatches(linha)) {
      if (marca.start > inicio) {
        trechos.add(TextSpan(text: linha.substring(inicio, marca.start)));
      }

      final negrito = marca.group(1);

      if (negrito != null) {
        trechos.add(
          TextSpan(
            text: negrito,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cores.primary,
            ),
          ),
        );
      } else {
        trechos.add(
          TextSpan(
            text: marca.group(2),
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: cores.secondary,
              decorationThickness: 2,
            ),
          ),
        );
      }

      inicio = marca.end;
    }

    if (inicio < linha.length) {
      trechos.add(TextSpan(text: linha.substring(inicio)));
    }

    return TextSpan(children: trechos);
  }
}
