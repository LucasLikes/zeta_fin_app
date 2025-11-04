import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:zeta_fin_app/core/routes/go_router.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';
import 'package:zeta_fin_app/core/services/transaction_service.dart';
import 'package:zeta_fin_app/features/repositories/user_auth_repository.dart';
import 'package:zeta_fin_app/features/goals/controllers/user_auth_controller.dart';
import 'package:zeta_fin_app/features/expenses/controllers/transaction_controller.dart';
import 'package:zeta_fin_app/core/state/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa os serviços
  final dioClient = DioClient();
  
  // Cria o TransactionService passando o Dio do DioClient
  final transactionService = TransactionService(dio: dioClient.dio);
  
  final authController = AuthController(
    authRepository: AuthRepository(dioClient: dioClient),
  );

  bool isLoggedIn = await authController.isLoggedIn();

  runApp(
    // ===== MULTIPROVIDER COM TODOS OS CONTROLLERS =====
    MultiProvider(
      providers: [
        // Estado de autenticação
        ChangeNotifierProvider(
          create: (_) => AuthState(isLoggedIn: isLoggedIn),
        ),
        
        // Controller de transações
        ChangeNotifierProvider(
          create: (_) => TransactionController(
            transactionService: transactionService,
          ),
        ),
        
        // Adicione outros controllers aqui conforme necessário
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final appRouter = AppRouter(authState: authState);

    return MaterialApp.router(
      routerConfig: appRouter.router,
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