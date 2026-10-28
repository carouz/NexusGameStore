// PONTO DE ENTRADA do aplicativo Nexus Game Store.
import 'package:flutter/material.dart';
import 'database/banco_dados.dart';
import 'views/login.dart';
import 'widgets/cores.dart';

// "async" porque precisamos esperar o banco SQLite abrir antes de mostrar a tela.
Future<void> main() async {
  // Necessario quando usamos plugins (sqflite) antes do runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await BancoDados.instancia; // abre/cria o banco e as tabelas
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Game Store',
      debugShowCheckedModeBanner: false,
      // Tema escuro com as cores do prototipo HTML.
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Cores.fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Cores.primaria,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Cores.fundoEscuro,
          foregroundColor: Colors.white,
        ),
      ),
      home: const Login(), // primeira tela do app
    );
  }
}
