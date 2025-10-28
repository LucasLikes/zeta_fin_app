import 'package:go_router/go_router.dart';
import '../../features/goals/screens/login/forgot_password_screen.dart';
import '../../features/goals/screens/login/login_screen.dart';
import '../../features/goals/screens/home_screen.dart';
import '../../features/goals/screens/login/cadastro_screen.dart';  // Importe a tela de Cadastro

final GoRouter goRouter = GoRouter(
  initialLocation: '/login',  // Define a tela inicial como login
  routes: [
    // Rota para a página de login
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    // Rota para a página Home após o login
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    // Rota para a página de Cadastro
    GoRoute(
      path: '/cadastro',
      builder: (context, state) => CadastroScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
        builder:(context, state) => ForgotPasswordScreen() // A tela que você criou para "Esqueci a Senha"
    ),
  ],
);
