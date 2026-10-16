/// O aluno logado no app.
class Usuario {
  final String nome;

  const Usuario({required this.nome});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(nome: json['nome'] as String);
  }
}
