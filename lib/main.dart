import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/routes/go_router.dart';
import 'core/services/dio_client.dart';
import 'features/repositories/user_auth_repository.dart';
import 'features/goals/controllers/user_auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authController = AuthController(
    authRepository: AuthRepository(dioClient: DioClient()),
  );

  bool isLoggedIn = await authController.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(isLoggedIn: isLoggedIn); // ✅ usa o novo router

    return MaterialApp.router(
      routerConfig: appRouter.router, // ✅ substitui _router pelo novo
      title: 'ZetaFin App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF4CAF50)),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
