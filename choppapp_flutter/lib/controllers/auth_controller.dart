// lib/controllers/auth_controller.dart
import '../models/auth_model.dart';

class AuthController {
  final AuthModel _authModel;

  AuthController(this._authModel);

  // Método para fazer login
  Future<bool> loginUser(String email, String password) async {
    return await _authModel.login(email, password);
  }

  // Método para registrar o usuário
  Future<bool> signUpUser(String email, String password) async {
    return await _authModel.signUp(email, password);
  }

  // Método para verificar se o usuário está logado
  bool isLoggedIn() {
    return _authModel.isAuthenticated();
  }

  // Método para fazer logout
  Future<void> logoutUser() async {
    await _authModel.logout();
  }
}
