import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/routes/go_router.dart';

void main() {
  // Simulação de usuário logado ou não
  final appRouter = AppRouter(isLoggedIn: false); // ou true se quiser testar home

  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.router, // ✅ usa o router corretamente
      title: 'ZetaFin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
