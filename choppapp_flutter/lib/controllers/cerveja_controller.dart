// controllers/cerveja_controller.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cerveja_model.dart';

class CervejaController {
  final supabase = Supabase.instance.client;

  Future<List<Cerveja>> getCervejas() async {
    final response = await supabase.from('cerveja').select();

    if (response.isEmpty) {
      throw Exception('Erro ao carregar cervejas');
    }

    return (response as List<dynamic>).map((data) => Cerveja.fromMap(data)).toList();
  }
}
