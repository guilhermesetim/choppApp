import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:intl/intl.dart';  // Para formatar as datas

class ConsumptionHistoryPage extends StatefulWidget {
  final String userId;  // Passe o ID do usuário ao navegar para essa página
  
  ConsumptionHistoryPage({required this.userId});

  @override
  _ConsumptionHistoryPageState createState() => _ConsumptionHistoryPageState();
}

class _ConsumptionHistoryPageState extends State<ConsumptionHistoryPage> {
  Future<List<dynamic>> _getConsumptionHistory() async {
    final supabase = Supabase.instance.client;

    // Query para buscar o histórico de consumo, incluindo os dados da cerveja relacionada
    final response = await supabase
        .from('consumo')
        .select('created_at, quantidade, valor, cerveja(nome)')
        .eq('id_user', widget.userId)  // Filtra pelo ID do cliente
        .order('created_at', ascending: false);  // Ordena do mais recente para o mais antigo
        

    if (response.isEmpty) {
      throw Exception('Não possui histórico de consumo para esse usuário');
    }

    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Consumo')),
      body: FutureBuilder<List<dynamic>>(
        future: _getConsumptionHistory(),
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
                //DataColumn(label: Text('Quantidade')),
                DataColumn(label: Text('Valor')),
              ],
              rows: consumptionHistory.map<DataRow>((item) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(DateFormat('dd/MM/yyyy H:m').format(DateTime.parse(item['created_at'])))),
                    DataCell(Text(item['cerveja']['nome'] ?? '')),
                    //DataCell(Text(item['quantidade'].toString())),
                    DataCell(Text('R\$ ${item['valor'].toStringAsFixed(2)}')),
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
