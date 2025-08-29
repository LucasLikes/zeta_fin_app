import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usando o degradê verde confortável
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

                  // Card com os campos de login
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Borda arredondada
                    ),
                    elevation: 8, // Sombra para dar um efeito de destaque
                    color: Colors.white, // Cor do card
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Título dentro do card
                          // "Logo" - apenas texto temporário
                          Align(
                            alignment: Alignment.centerLeft,  // Alinha o texto à esquerda
                            child: Text(
                              'Logo',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromARGB(255, 0, 0, 0), // Cor da logo
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                              alignment: Alignment.centerLeft,  // Alinha o texto à esquerda
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    // Parte "Bem-vindo" em preto
                                    TextSpan(
                                      text: 'Bem-vindo ',
                                      style: TextStyle(
                                        color: const Color.fromARGB(214, 0, 0, 0),
                                      ), // Texto preto
                                    ),
                                    // Parte "de volta" em verde
                                    TextSpan(
                                      text: 'de volta!',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 74, 212, 81),
                                      ), // Texto verde
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
                                color: const Color.fromARGB(255, 141, 141, 141),
                                
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(214, 0, 0, 0),
                              ), // Cor do label
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(214, 0, 0, 0),
                                  width: 1,
                                ), // Borda verde escuro
                              ),
                              filled: true,
                              fillColor:
                                  Colors.white, // Fundo do campo de texto
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
                                color: Color.fromARGB(255, 141, 141, 141)
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
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 141, 141, 141),
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color.fromARGB(255, 141, 141, 141), // Ícone verde
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),

                          // Botão de Login
                          ElevatedButton(
                            onPressed: () {
                              // Lógica de login
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              print('Login com: $email, $password');
                            },
                            child: Text(
                              'Entrar',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Texto em branco no botão
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                0xFF388E3C,
                              ), // Verde escuro
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 120,
                              ),
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
                                color: Color(
                                  0xFF388E3C,
                                ), // Texto em verde escuro
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
