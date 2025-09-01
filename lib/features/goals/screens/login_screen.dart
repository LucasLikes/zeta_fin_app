import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/dio_client.dart';
import '../../repositories/user_auth_repository.dart';
import '../controllers/user_auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscured = true;
  late AuthController _authController; // Definindo o AuthController como late, mas vamos inicializar no initState()

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository(dioClient: DioClient());
    _authController = AuthController(authRepository: authRepository); // Inicialização correta do AuthController
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validar se os campos de e-mail e senha estão preenchidos
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, preencha todos os campos!')));
      return;
    }

    try {
      // Chamando o controller para fazer o login
      await _authController.login(email, password);

      // Após o login bem-sucedido, a navegação para a próxima tela ocorre
      Navigator.pushReplacementNamed(context, '/home'); // Altere '/home' para sua rota de destino
    } catch (e) {
      // Exibir erro caso algo dê errado no login
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro de login: $e')));
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
                          // Rótulo e Campo de E-mail
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

                          // Rótulo e Campo de Senha
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
                          SizedBox(height: 40),

                          // Botão de Login
                          ElevatedButton(
                            onPressed: _login,
                            child: Text(
                              'Entrar',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Texto em branco no botão
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF388E3C),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5, // Sombra suave
                            ),
                          ),
                          SizedBox(height: 20),

                          // Link para cadastro
                          TextButton(
                            onPressed: () {
                              print('Ir para Cadastro');
                            },
                            child: Text(
                              'Ainda não tem conta? Cadastre-se',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF388E3C),
                                fontSize: 14,
                              ),
                            ),
                          ),
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
