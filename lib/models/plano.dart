class Plano {
  final String nome;

  final int aulasPorSemana;

  final double preco;

  final String descricao;

  final bool destaque;

  const Plano({
    required this.nome,
    required this.aulasPorSemana,
    required this.preco,
    required this.descricao,
    this.destaque = false,
  });

  String get precoFormatado {
    final valor = preco.toStringAsFixed(2).replaceAll('.', ',');

    return 'R\$ $valor/mês';
  }

  factory Plano.fromJson(Map<String, dynamic> json) {
    return Plano(
      nome: json['nome'] as String,
      aulasPorSemana: json['aulasPorSemana'] as int,
      preco: (json['preco'] as num).toDouble(),
      descricao: json['descricao'] as String,
      destaque: json['destaque'] as bool? ?? false,
    );
  }
}
