import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/services/dio_client.dart';
import 'features/goals/controllers/user_auth_controller.dart';
import 'features/goals/screens/login/cadastro_screen.dart';
import 'features/goals/screens/home_screen.dart';
import 'features/goals/screens/login/forgot_password_screen.dart';
import 'features/goals/screens/login/login_screen.dart';
import 'features/repositories/user_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Instanciando o AuthController e verificando se o usuário está logado
  final authController = AuthController(authRepository: AuthRepository(dioClient: DioClient()));
  bool isLoggedIn = await authController.isLoggedIn();

  // Inicializando o app com o estado de login
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // Configuração do GoRouter
      title: 'ZetaFin App',
      themeMode: ThemeMode.dark, // Definindo o tema escuro para o início
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Definindo o tema escuro
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFF121212), // Fundo escuro
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
        brightness: Brightness.light, // Tema claro
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

  GoRouter get _router {
    return GoRouter(
      initialLocation: isLoggedIn ? '/home' : '/login', // Se estiver logado vai para Home, caso contrário para Login
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/cadastro',
          builder: (context, state) => CadastroScreen(),
      ),
        GoRoute(
          path: '/forgot-password',
          builder: (BuildContext context, GoRouterState state) {
            return ForgotPasswordScreen(); // A tela que você criou para "Esqueci a Senha"
          },
        ),
      ],
    );
  }
}
