// lib/models/auth_model.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel {
  final SupabaseClient _client;

  AuthModel(this._client);

  // Método de Login
  Future<bool> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
  
    if( response.user == null ) {
      return false;
    }

    return true;
  
  }

  // Método de Cadastro
  Future<bool> signUp(String email, String password) async {
     final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    if( response.user == null ) {
      return false;
    }

    return true;
  }

  // Método para verificar se o usuário está autenticado
  bool isAuthenticated() {
    return _client.auth.currentUser != null;
  }

  // Método de Logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
