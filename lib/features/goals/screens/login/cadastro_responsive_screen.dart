import 'package:flutter/material.dart';
import 'package:zeta_fin_app/features/goals/screens/login/desktop/cadastro_desktop_layout.dart';
import 'package:zeta_fin_app/features/goals/screens/login/mobile/cadastro_screen.dart';

class CadastroResponsiveScreen extends StatelessWidget {
  const CadastroResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Definimos 800px como breakpoint entre mobile e desktop
        if (constraints.maxWidth >= 800) {
          return const CadastroDesktopScreen();
        } else {
          return const CadastroScreen();
        }
      },
    );
  }
}
