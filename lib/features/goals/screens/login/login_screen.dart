import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';
import 'package:zeta_fin_app/features/goals/controllers/user_auth_controller.dart';
import '../../../repositories/user_auth_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;
  late AuthController _authController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository(dioClient: DioClient());
    _authController = AuthController(authRepository: authRepository);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos!';
      });
      return;
    }

    try {
      await _authController.login(email, password);
      
      // Reset any previous error message
      setState(() {
        _errorMessage = null;
      });

      // Mensagem de sucesso após o login bem-sucedido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido!')),
      );

      // Transição suave para a HomeScreen com GoRouter
      context.go('/home'); // Navegação usando GoRouter
    } catch (e) {
      // Mensagens personalizadas de erro para login
      String errorMessage = 'Erro de login: Verifique suas credenciais.';

      if (e.toString().contains('401')) {
        errorMessage = 'E-mail ou senha incorretos!';
      } else if (e.toString().contains('NetworkException')) {
        errorMessage = 'Erro de conexão. Verifique sua internet.';
      } else {
        errorMessage = 'Erro desconhecido. Tente novamente.';
      }

      // Exibir erro
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 26, 95, 30), // Verde escuro no topo
              Color.fromARGB(255, 47, 107, 51), // Verde mais claro no fundo
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Logo',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Bem-vindo ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'de volta!',
                                    style: TextStyle(color: Color.fromARGB(255, 74, 212, 81)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),

                          // Campo de E-mail
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 141, 141, 141),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.black, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Campo de Senha
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Senha',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 141, 141, 141),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.black, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured ? Icons.visibility_off : Icons.visibility,
                                  color: Color.fromARGB(255, 141, 141, 141),
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Exibir mensagem de erro, se houver
                          if (_errorMessage != null)
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error, color: Colors.red, size: 18),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(color: Colors.red, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 40),

                          // Botão de Login
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF388E3C),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5, // Sombra suave
                            ),
                            child: Text(
                              'Entrar',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Texto em branco no botão
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Link para "Esqueci a senha?"
                          TextButton(
                            onPressed: () {
                              // Navegar para a tela de Esqueci a Senha
                              context.go('/forgot-password'); // Rota configurada no GoRouter
                            },
                            child: Text(
                              'Esqueci a senha?',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF388E3C), // Cor verde para o texto
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // Link para cadastro
                          TextButton(
                            onPressed: () {
                              // Ação quando o link for clicado
                              context.go('/cadastro'); // Navegação para a tela de cadastro
                            },
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF388E3C), // Cor verde para o texto inteiro por padrão
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Ainda não tem conta? ',
                                    style: TextStyle(
                                      color: Colors.black, // Cor preta para a primeira parte da frase
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: TextStyle(
                                      color: Color(0xFF388E3C), // Cor verde para a palavra "Cadastre-se"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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
}
