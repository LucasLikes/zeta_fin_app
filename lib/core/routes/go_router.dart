import 'package:go_router/go_router.dart';
import 'package:zeta_fin_app/features/goals/screens/login/forgot_response.dart';
import '../../features/goals/screens/login/mobile/login_mobile_layout.dart';
import '../../features/goals/screens/home_screen.dart';
import '../../features/goals/screens/login/mobile/cadastro_screen.dart';  // Importe a tela de Cadastro

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
        builder:(context, state) => ForgotPasswordResponsiveScreen()
    ),
  ],
);
