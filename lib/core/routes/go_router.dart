import 'package:go_router/go_router.dart';
import 'package:zeta_fin_app/features/goals/screens/expenses/desktop/expenses_desktop_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/goal/desktop/goals_desktop.dart';

// ====== Importações das telas ======
import 'package:zeta_fin_app/features/goals/screens/home/home_responsive.dart';
import 'package:zeta_fin_app/features/goals/screens/login/login_responsive_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/login/cadastro_responsive_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/login/forgot_response.dart';

class AppRouter {
  final bool isLoggedIn;

  AppRouter({required this.isLoggedIn});

  late final GoRouter router = GoRouter(
    initialLocation: isLoggedIn ? '/home' : '/login',

    routes: [
      // ===== LOGIN =====
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginResponsiveScreen(),
      ),

      // ===== HOME =====
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeResponsiveScreen(),
      ),

      // ===== MINHAS DESPESAS =====
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesDesktopScreen(),
      ),

      // ===== CADASTRO =====
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroResponsiveScreen(),
      ),

      // ===== ESQUECEU SENHA =====
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordResponsiveScreen(),
      ),

      // ===== METAS =====
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsDesktopScreen(),
      ),
    ],

    // Redirecionamento simples
    redirect: (context, state) {
      final logged = isLoggedIn;
      final loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/cadastro';

      if (!logged && !loggingIn) return '/login';
      if (logged && loggingIn) return '/home';
      return null;
    },
  );
}
