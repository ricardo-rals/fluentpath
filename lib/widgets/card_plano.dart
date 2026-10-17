import 'package:flutter/material.dart';

import '../models/plano.dart';

class CardPlano extends StatelessWidget {
  final Plano plano;

  final VoidCallback? onTap;

  final bool atual;

  final bool mostrarDestaque;

  const CardPlano({
    super.key,
    required this.plano,
    this.onTap,
    this.atual = false,
    this.mostrarDestaque = true,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    final cores = tema.colorScheme;

    final destacado = plano.destaque && mostrarDestaque;

    final aulas = plano.aulasPorSemana == 1
        ? '1 aula por semana'
        : '${plano.aulasPorSemana} aulas por semana';

    var borda = BorderSide.none;

    if (atual) {
      borda = BorderSide(color: cores.primary, width: 2);
    } else if (destacado) {
      borda = BorderSide(color: cores.secondary, width: 2);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borda,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plano.nome,
                          style: tema.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (atual)
                          _Etiqueta(
                            texto: 'Seu plano',
                            fundo: cores.primary,
                            cor: cores.onPrimary,
                          )
                        else if (destacado)
                          _Etiqueta(
                            texto: 'Mais escolhido',
                            fundo: cores.secondary,
                            cor: Colors.black87,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(aulas),
                    const SizedBox(height: 2),
                    Text(
                      plano.descricao,
                      style: tema.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                plano.precoFormatado,
                textAlign: TextAlign.right,
                style: tema.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cores.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String texto;

  final Color fundo;

  final Color cor;

  const _Etiqueta({
    required this.texto,
    required this.fundo,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: cor,
        ),
      ),
    );
  }
}
