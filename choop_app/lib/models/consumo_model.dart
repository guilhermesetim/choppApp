// models/consumo_model.dart
import 'package:intl/intl.dart';

class Consumo {
  final DateTime createdAt;
  final String cervejaNome;
  final double valor;

  Consumo({
    required this.createdAt,
    required this.cervejaNome,
    required this.valor,
  });

  factory Consumo.fromMap(Map<String, dynamic> map) {
    return Consumo(
      createdAt: DateTime.parse(map['created_at']),
      cervejaNome: map['cerveja']['nome'] ?? '',
      valor: map['valor'].toDouble(),
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy H:m').format(createdAt);
  }
}
