import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/routes/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool _isDarkMode = true; // Inicia no modo escuro

  // Função para alternar entre o tema claro e escuro
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter, // Configuração da navegação com GoRouter
      title: 'ZetaFin App',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Controlando o tema
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFF121212), // Fundo escuro confortável
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF4CAF50)), // Verde da marca
          bodyMedium: TextStyle(color: Colors.white70),
          displayLarge: TextStyle(color: Color(0xFF4CAF50)),
          displayMedium: TextStyle(color: Color(0xFF4CAF50)),
          displaySmall: TextStyle(color: Color(0xFF4CAF50)),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[600],
          titleTextStyle: TextStyle(color: Colors.black),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF4CAF50)), // Verde da marca
          bodyMedium: TextStyle(color: Colors.black87),
          displayLarge: TextStyle(color: Color(0xFF4CAF50)),
          displayMedium: TextStyle(color: Color(0xFF4CAF50)),
          displaySmall: TextStyle(color: Color(0xFF4CAF50)),
        ),
      ),
    );
  }
}
