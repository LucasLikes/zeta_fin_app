import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeta_fin_app/core/state/auth_state.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';
import 'package:zeta_fin_app/core/theme/app_text_styles.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';
import 'package:zeta_fin_app/features/goals/controllers/user_auth_controller.dart';
import 'package:zeta_fin_app/features/repositories/user_auth_repository.dart';
import 'package:zeta_fin_app/shared/widget/custom_button.dart';
import 'package:zeta_fin_app/shared/widget/custom_text_field.dart';
import 'package:zeta_fin_app/shared/widget/social_auth_button.dart';

class LoginDesktopScreen extends StatefulWidget {
  const LoginDesktopScreen({super.key});

  @override
  State<LoginDesktopScreen> createState() => _LoginDesktopScreenState();
}

class _LoginDesktopScreenState extends State<LoginDesktopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AuthController _authController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository(dioClient: DioClient());
    _authController = AuthController(authRepository: authRepository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
  setState(() => _errorMessage = null);

  if (!_formKey.currentState!.validate()) return;

  String email = _emailController.text.trim();
  String password = _passwordController.text;

  setState(() => _isLoading = true);

  try {
    final authState = Provider.of<AuthState>(context, listen: false);

    await _authController.login(email, password, authState);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Login realizado com sucesso!'),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/home'); // ou deixe o authState redirecionar
  } catch (e) {
    setState(() {
      _errorMessage = 'Erro ao realizar login. Tente novamente.';
      _isLoading = false;
    });
  }
}


  void _handleGoogleSignIn() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Google Sign In em desenvolvimento'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAppleSignIn() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Apple Sign In em desenvolvimento'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                children: [
                  // Lado esquerdo: Logo e Nome
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.savings_outlined,
                              size: 50,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'ZetaFin',
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Controle suas finanças de forma fácil e rápida.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Lado direito: Formulário
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(48),
                      child: _buildFormCard(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo de volta!',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              'Faça login para continuar',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            CustomTextField(
              hintText: 'seu@email.com',
              labelText: 'E-mail',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira seu e-mail';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Por favor, insira um e-mail válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: '••••••••',
              labelText: 'Senha',
              controller: _passwordController,
              isPassword: true,
              prefixIcon: Icons.lock_outline,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/forgot-password'),
                child: Text('Esqueci minha senha', style: AppTextStyles.link.copyWith(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Entrar',
              onPressed: _login,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Ou continue com', style: TextStyle(fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            SocialAuthButton(type: SocialAuthType.google, onPressed: _handleGoogleSignIn),
            const SizedBox(height: 12),
            SocialAuthButton(type: SocialAuthType.apple, onPressed: _handleAppleSignIn),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ainda não tem conta? ', style: AppTextStyles.bodySmall),
                GestureDetector(
                  onTap: () => context.go('/cadastro'),
                  child: Text('Cadastre-se', style: AppTextStyles.link),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
