import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';
import 'package:zeta_fin_app/core/theme/app_text_styles.dart';
import 'package:zeta_fin_app/shared/widget/custom_button.dart';
import 'package:zeta_fin_app/shared/widget/custom_text_field.dart';

class ForgotPasswordDesktopScreen extends StatefulWidget {
  const ForgotPasswordDesktopScreen({super.key});

  @override
  State<ForgotPasswordDesktopScreen> createState() => _ForgotPasswordDesktopScreenState();
}

class _ForgotPasswordDesktopScreenState extends State<ForgotPasswordDesktopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simula requisição para enviar link
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Link de redefinição enviado!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      context.pop(); // Volta para login
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao enviar o link. Tente novamente.';
        _isLoading = false;
      });
    }
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
                  // Lado esquerdo: Logo e descrição
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
                            child: const Icon(Icons.savings_outlined, size: 50, color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'ZetaFin',
                            style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 48),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Redefina sua senha de forma fácil e rápida.',
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70, fontSize: 18),
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
            Text('Esqueci minha senha', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Informe seu e-mail para receber o link de redefinição',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
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
            const SizedBox(height: 24),
            CustomButton(
              text: 'Enviar Link',
              onPressed: _sendResetLink,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.go('/login'), // Redireciona para a tela de login responsiva
              child: Text(
                'Voltar para login',
                style: AppTextStyles.link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
