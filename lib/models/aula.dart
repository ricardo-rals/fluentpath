enum StatusAula { agendada, confirmada }

class Aula {
  final String titulo;

  final DateTime data;

  StatusAula status;

  Aula({
    required this.titulo,
    required this.data,
    this.status = StatusAula.agendada,
  });

  factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
      titulo: json['titulo'] as String,
      data: DateTime.parse(json['data'] as String),
      status: StatusAula.values.byName(json['status'] as String),
    );
  }
}
