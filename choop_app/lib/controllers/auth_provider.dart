import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _client;
  User? _user;
  double _balance = 0.0;
  String _nome = '';
  int _cod = 0;

  // Mapa para armazenar o preço das cervejas
  Map<int, double> _cervejaPrecos = {};

  AuthProvider(this._client) {
    _user = _client.auth.currentUser;
    if (_user != null) {
      fetchBalance(); // Carrega o saldo ao inicializar o provedor
      fetchCervejas(); // Carrega as cervejas ao inicializar o provedor
    }
  }

  User? get user => _user;
  int get cod => _cod;
  double get balance => _balance;
  String get nome => _nome;
  Map<int, double> get cervejaPrecos => _cervejaPrecos;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        await fetchBalance(); // Carrega o saldo após login
        await fetchCervejas(); // Carrega as cervejas após login
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    _user = null;
    _balance = 0.0; // Reseta o saldo ao fazer logout
    _cervejaPrecos.clear(); // Limpa os preços das cervejas
    notifyListeners();
  }

  // Método de Cadastro
  // Método de Cadastro
Future<bool> signUp(String email, String password, String nome) async {
  final supabase = Supabase.instance.client;

  try {
    // Realiza o cadastro e obtém a resposta
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    // Verifica se o usuário foi criado com sucesso
    if (response.user == null) {
      return false;
    }

    // Obtém o UID do usuário recém-cadastrado
    final uid = response.user!.id;

    // Insere os dados adicionais na tabela 'usuarios'
    await supabase.from('usuarios').insert({
      'nome': nome,
      'uid': uid,
      'saldo': 0.0,
    });

    return true;
  } catch (e) {
    print('Erro no cadastro: $e');
    return false;
  }
}


  Future<void> fetchCervejas() async {
    if (_user != null) {
      final response = await _client
          .from('cerveja')
          .select('id, valor');;

      if (response.isNotEmpty) {
        // Preenche o mapa de preços das cervejas
        for (var cerveja in response) {
          _cervejaPrecos[cerveja['id']] = cerveja['valor'];
        }
        notifyListeners();
      } else {
        print('Erro ao buscar preços das cervejas: ${response}');
      }
    }
  }

  Future<void> fetchBalance() async {
    if (_user != null) {
      final response = await _client
          .from('usuarios')
          .select('saldo, nome,id')
          .eq('uid', _user!.id)
          .single();

      if (response.isNotEmpty) {
        _balance = response['saldo'].toDouble() ?? 0.0;
        _nome = response['nome'] ?? '';
        _cod = response['id'] ?? 0;
        notifyListeners();
      } else {
        print('Erro ao buscar saldo: ${response}');
      }
    }
  }

  Future<void> updateBalance(double valueToAdd) async {
    final uid = _user?.id;

    if (uid != null) {
      try {
        // Atualiza o saldo no Supabase
        await _client
            .from('usuarios')
            .update({'saldo': balance + valueToAdd})
            .eq('uid', uid);

        // Atualiza o saldo localmente
        _balance += valueToAdd;

        // Notifica os listeners para atualizar a interface
        notifyListeners();

      } catch (e) {
        print('Erro ao atualizar saldo: $e');
      }
    }
  }

  // Função para obter o preço de uma cerveja específica
  double getCervejaPreco(int cervejaId) {
    return _cervejaPrecos[cervejaId] ?? 0.0; // Retorna o preço ou 0 se não encontrado
  }
}
