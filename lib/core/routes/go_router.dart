import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeta_fin_app/core/state/auth_state.dart';
import 'package:zeta_fin_app/features/goals/screens/expenses/desktop/expenses_desktop_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/goal/desktop/goals_desktop.dart';

// ====== Importações das telas ======
import 'package:zeta_fin_app/features/goals/screens/home/home_responsive.dart';
import 'package:zeta_fin_app/features/goals/screens/login/login_responsive_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/login/cadastro_responsive_screen.dart';
import 'package:zeta_fin_app/features/goals/screens/login/forgot_response.dart';
import 'package:zeta_fin_app/features/goals/screens/myAccount/desktop/my_account_desktop_screen.dart';

class AppRouter {
  final AuthState authState;

  AppRouter({required this.authState});

  late final GoRouter router = GoRouter(
    initialLocation: '/login',

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginResponsiveScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeResponsiveScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesDesktopScreen(),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroResponsiveScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordResponsiveScreen(),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsDesktopScreen(),
      ),
      GoRoute(
      path: '/my-account',
      builder: (context, state) => const MyAccountDesktopScreen(),
    ),
    ],

    redirect: (context, state) {
      final logged = authState.isLoggedIn;
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/cadastro';

      if (!logged && !loggingIn) return '/login';
      if (logged && loggingIn) return '/home';
      return null;
    },
    refreshListenable: authState,
  );
}

