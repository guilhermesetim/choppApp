// controllers/usuario_controller.dart
import 'package:flutter/material.dart';
import '../controllers/auth_provider.dart';

class UsuarioController {
  final AuthProvider authProvider;

  UsuarioController({required this.authProvider});

  double getSaldo() {
    return authProvider.balance;
  }

  Future<void> adicionarCreditos(double valor) async {
    // Atualiza o saldo do usuário
    await authProvider.updateBalance(valor);
  }

  Future<bool?> confirmarAdicaoDeCreditos(BuildContext context, double valor) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Deseja adicionar R\$ ${valor.toStringAsFixed(2)} ao seu saldo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
