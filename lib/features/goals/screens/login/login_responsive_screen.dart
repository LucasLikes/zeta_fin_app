import 'package:flutter/material.dart';
import 'package:zeta_fin_app/features/goals/screens/login/desktop/login_desktop_layout.dart';
import 'package:zeta_fin_app/features/goals/screens/login/mobile/login_mobile_layout.dart';


class LoginResponsiveScreen extends StatelessWidget {
  const LoginResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // breakpoint 800px, você pode ajustar
        if (constraints.maxWidth >= 800) {
          return const LoginDesktopScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
