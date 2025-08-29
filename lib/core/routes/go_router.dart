import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/goals/screens/login_screen.dart';
import '../../features/goals/screens/goals_screen.dart';


final GoRouter goRouter = GoRouter(
  initialLocation: '/login',  // Define a tela inicial como login
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/goals',
      builder: (context, state) => GoalsScreen(),
    ),
    // Adicione outras rotas conforme necessário
  ],
);