class Contato {
  final String nome;

  final String email;

  final String telefone;

  final String? plano;

  final String? mensagem;

  const Contato({
    required this.nome,
    required this.email,
    required this.telefone,
    this.plano,
    this.mensagem,
  });
}
