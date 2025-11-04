import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';
import 'package:zeta_fin_app/core/theme/app_text_styles.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';
import 'package:zeta_fin_app/features/goals/controllers/user_auth_controller.dart';
import 'package:zeta_fin_app/features/repositories/user_auth_repository.dart';
import 'package:zeta_fin_app/shared/widget/custom_button.dart';
import 'package:zeta_fin_app/shared/widget/custom_text_field.dart';
import 'package:zeta_fin_app/shared/widget/social_auth_button.dart';

class CadastroDesktopScreen extends StatefulWidget {
  const CadastroDesktopScreen({super.key});

  @override
  State<CadastroDesktopScreen> createState() => _CadastroDesktopScreenState();
}

class _CadastroDesktopScreenState extends State<CadastroDesktopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      await _authController.cadastrar(name, email, password);

      if (!mounted) return;

      // Agora sim, finaliza o loading após sucesso
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cadastro realizado com sucesso!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      context.go('/login');
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao cadastrar. Tente novamente.';
        _isLoading = false;
      });
    }
  }

  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Google Sign In em desenvolvimento'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAppleSignIn() {
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
                  // Lado esquerdo (logo e descrição)
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
                            'Cadastre-se e comece a controlar suas finanças de forma fácil e rápida.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Lado direito (formulário)
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
            Text('Crie sua conta', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Cadastre-se para começar a usar o app',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Mensagem de erro
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
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Campos
            CustomTextField(
              hintText: 'Seu nome',
              labelText: 'Nome',
              controller: _nameController,
              prefixIcon: Icons.person_outline,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Por favor, insira seu nome' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'seu@email.com',
              labelText: 'E-mail',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu e-mail';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
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
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter no mínimo 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Botão principal
            CustomButton(
              text: 'Cadastrar',
              onPressed: _isLoading ? () {} : () => _cadastrar(),
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),

            // Linha divisória
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Ou continue com',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),

            // Botões sociais
            SocialAuthButton(
              type: SocialAuthType.google,
              onPressed: _handleGoogleSignIn,
            ),
            const SizedBox(height: 12),
            SocialAuthButton(
              type: SocialAuthType.apple,
              onPressed: _handleAppleSignIn,
            ),
            const SizedBox(height: 24),

            // Link para login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Já possui conta? ', style: AppTextStyles.bodySmall),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text('Faça login', style: AppTextStyles.link),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
