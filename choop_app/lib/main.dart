import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/auth_provider.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fpributmimyhqsvnmziy.supabase.co',  // Substitua pelo seu URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZwcmlidXRtaW15aHFzdm5teml5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM5ODUxMTYsImV4cCI6MjAzOTU2MTExNn0.UprOjTQSMDuX7QKu2oi9pokQ0QSWL1DCfyL0ZhykQAo',  // Substitua pela sua anonKey
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(Supabase.instance.client),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Verificar se o usuário está logado
    if (authProvider.user != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}






