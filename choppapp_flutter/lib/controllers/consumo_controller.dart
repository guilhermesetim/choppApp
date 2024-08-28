// controllers/consumo_controller.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/consumo_model.dart';

class ConsumoController {
  final supabase = Supabase.instance.client;

  Future<List<Consumo>> getConsumptionHistory(String userId) async {
    final response = await supabase
        .from('consumo')
        .select('created_at, quantidade, valor, cerveja(nome)')
        .eq('id_user', userId)
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('Não possui histórico de consumo para esse usuário');
    }

    return (response as List<dynamic>).map((data) => Consumo.fromMap(data)).toList();
  }
}
