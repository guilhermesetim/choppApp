// models/usuario_model.dart
class Usuario {
  double saldo;

  Usuario({required this.saldo});

  // Método para atualizar o saldo
  void adicionarSaldo(double valor) {
    saldo += valor;
  }
}
