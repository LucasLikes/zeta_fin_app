import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeta_fin_app/features/goals/screens/home/home_responsive.dart';
import 'package:zeta_fin_app/features/goals/screens/login/cadastro_responsive_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/login/forgot_response.dart';
import 'package:zeta_fin_app/features/goals/screens/login/login_responsive_screen.dart';
import 'core/services/dio_client.dart';
import 'features/goals/controllers/user_auth_controller.dart';
import 'features/repositories/user_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Instanciando o AuthController e verificando se o usuário está logado
  final authController = AuthController(
    authRepository: AuthRepository(dioClient: DioClient()),
  );
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
        //primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFF121212), // Fundo escuro
        appBarTheme: AppBarTheme(
          //backgroundColor: Colors.green[800],
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
        scaffoldBackgroundColor: Colors.white, // fundo branco global
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // deixa a AppBar branca também
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          displayLarge: TextStyle(color: Colors.black87),
          displayMedium: TextStyle(color: Colors.black87),
          displaySmall: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  GoRouter get _router {
    return GoRouter(
      initialLocation: isLoggedIn
          ? '/home'
          : '/login', // Se estiver logado vai para Home, caso contrário para Login
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginResponsiveScreen(),
        ),
        GoRoute(path: '/home', builder: (context, state) => HomeResponsiveScreen()),
        GoRoute(
          path: '/cadastro',
          builder: (context, state) => CadastroResponsiveScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (BuildContext context, GoRouterState state) {
            return ForgotPasswordResponsiveScreen();
          },
        ),
      ],
    );
  }
}
