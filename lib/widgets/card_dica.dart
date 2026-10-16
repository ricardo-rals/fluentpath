import 'package:flutter/material.dart';

import '../models/dica.dart';

class CardDica extends StatelessWidget {
  final Dica dica;

  final VoidCallback? onTap;

  const CardDica({super.key, required this.dica, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: cores.primary.withValues(alpha: 0.12),
          foregroundColor: cores.primary,
          child: const Icon(Icons.lightbulb_outline),
        ),
        title: Text(
          dica.titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dica.conteudo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
