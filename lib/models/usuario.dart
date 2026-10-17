class Usuario {
  final String nome;

  final String? plano;

  const Usuario({required this.nome, this.plano});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'] as String,
      plano: json['plano'] as String?,
    );
  }
}
