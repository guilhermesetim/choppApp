import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class BuyCreditsPage extends StatelessWidget {
  final TextEditingController _creditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Comprar Créditos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Saldo atual: R\$ ${authProvider.balance.toStringAsFixed(2)}'),
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
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirmação'),
                        content: Text('Deseja adicionar R\$ ${valueToAdd.toStringAsFixed(2)} ao seu saldo?'),
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
                  
                  if (confirmed == true) {
                    await authProvider.updateBalance(valueToAdd);
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
