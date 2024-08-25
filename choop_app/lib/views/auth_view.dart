// lib/views/auth_view.dart
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class AuthView extends StatefulWidget {
  final AuthController authController;

  AuthView({required this.authController});

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isLogin ? 'Entrar' : 'Cadastrar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin
                  ? 'Não tem uma conta? Cadastre-se'
                  : 'Já tem uma conta? Faça login'),
            ),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    bool success;
    if (_isLogin) {
      success = await widget.authController.loginUser(email, password);
    } else {
      success = await widget.authController.signUpUser(email, password);
    }

    if (success) {
      setState(() {
        _message = _isLogin
            ? 'Login bem-sucedido!'
            : 'Cadastro realizado com sucesso!';
      });
    } else {
      setState(() {
        _message = _isLogin
            ? 'Erro no login. Verifique suas credenciais.'
            : 'Erro no cadastro. Tente novamente.';
      });
    }
  }
}
