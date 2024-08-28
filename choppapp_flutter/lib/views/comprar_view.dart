// views/buy_credits_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/comprar_controller.dart';
import '../controllers/auth_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class BuyCreditsPage extends StatelessWidget {
  final TextEditingController _creditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuarioController = UsuarioController(authProvider: authProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Comprar Créditos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Saldo atual: R\$ ${usuarioController.getSaldo().toStringAsFixed(2)}'),
            SizedBox(height: 20),
            TextField(
              controller: _creditController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Insira o valor em reais',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final valueToAdd = double.tryParse(_creditController.text);

                if (valueToAdd != null && valueToAdd > 0) {
                  final confirmed = await usuarioController.confirmarAdicaoDeCreditos(context, valueToAdd);

                  if (confirmed == true) {
                    await usuarioController.adicionarCreditos(valueToAdd);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saldo atualizado com sucesso!')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, insira um valor válido.')),
                  );
                }
              },
              child: Text('Adicionar Créditos'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
