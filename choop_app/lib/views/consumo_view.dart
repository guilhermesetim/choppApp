// views/consumption_history_page.dart
import 'package:flutter/material.dart';
import '../controllers/consumo_controller.dart';
import '../models/consumo_model.dart';
import '../widgets/bottom_nav_bar.dart';

class ConsumptionHistoryPage extends StatefulWidget {
  final String userId;

  ConsumptionHistoryPage({required this.userId});

  @override
  _ConsumptionHistoryPageState createState() => _ConsumptionHistoryPageState();
}

class _ConsumptionHistoryPageState extends State<ConsumptionHistoryPage> {
  final ConsumoController _consumoController = ConsumoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Consumo')),
      body: FutureBuilder<List<Consumo>>(
        future: _consumoController.getConsumptionHistory(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum histórico de consumo encontrado.'));
          }

          final consumptionHistory = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Data')),
                DataColumn(label: Text('Cerveja')),
                DataColumn(label: Text('Valor')),
              ],
              rows: consumptionHistory.map<DataRow>((item) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(item.formattedDate)),
                    DataCell(Text(item.cervejaNome)),
                    DataCell(Text('R\$ ${item.valor.toStringAsFixed(2)}')),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
