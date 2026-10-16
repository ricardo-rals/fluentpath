class Dica {
  final String titulo;

  final String conteudo;

  const Dica({required this.titulo, required this.conteudo});

  factory Dica.fromJson(Map<String, dynamic> json) {
    return Dica(
      titulo: json['titulo'] as String,
      conteudo: json['conteudo'] as String,
    );
  }
}
