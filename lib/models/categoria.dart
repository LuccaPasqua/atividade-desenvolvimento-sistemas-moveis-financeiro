class Categoria {
  final String id;
  final String nome;
  final String descricao;
  final DateTime created_at;


  Categoria({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.created_at
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricao: (json['descricao'] as String?) ?? '',
      created_at: DateTime.parse(json['created_at'] as String)
    );
  }
}
