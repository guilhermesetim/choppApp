import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/bottom_nav_bar.dart';

class CervejasPage extends StatefulWidget {
  @override
  _CervejasPageState createState() => _CervejasPageState();
}

class _CervejasPageState extends State<CervejasPage> {
  Future<List<dynamic>> _getCervejas() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('cerveja')
        .select('');

    if (response.isEmpty) {
      throw Exception('Erro ao carregar cervejas:');
    }

    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Cervejas'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getCervejas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma cerveja encontrada.'));
          }

          final cervejas = snapshot.data!;

          return ListView.builder(
            itemCount: cervejas.length,
            itemBuilder: (context, index) {
              final cerveja = cervejas[index];
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: cerveja['imagem'],
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        cerveja['nome'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Preço: R\$ ${cerveja['valor'].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      SizedBox(height: 5),
                      Text(
                        cerveja['descricao'],
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
