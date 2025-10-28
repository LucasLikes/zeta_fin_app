import 'package:flutter/material.dart';
import 'package:zeta_fin_app/features/goals/screens/login/desktop/forgot_password_desktop.dart';
import 'package:zeta_fin_app/features/goals/screens/login/mobile/forgot_password_screen.dart';

class ForgotPasswordResponsiveScreen extends StatelessWidget {
  const ForgotPasswordResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // breakpoint de 800px, pode ajustar conforme seu design
        if (constraints.maxWidth >= 800) {
          return const ForgotPasswordDesktopScreen();
        } else {
          return const ForgotPasswordMobileScreen();
        }
      },
    );
  }
}
