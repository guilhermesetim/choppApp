// models/cerveja_model.dart
class Cerveja {
  final String nome;
  final String descricao;
  final String imagem;
  final double valor;

  Cerveja({
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.valor,
  });

  factory Cerveja.fromMap(Map<String, dynamic> map) {
    return Cerveja(
      nome: map['nome'],
      descricao: map['descricao'],
      imagem: map['imagem'],
      valor: map['valor'].toDouble(),
    );
  }
}
