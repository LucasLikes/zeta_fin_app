import 'package:flutter/material.dart';
import 'package:zeta_fin_app/features/goals/screens/home/desktop/home_desktop.dart';
import 'package:zeta_fin_app/features/goals/screens/home/mobile/home_screen.dart';

class HomeResponsiveScreen extends StatelessWidget {
  const HomeResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // breakpoint 800px, você pode ajustar
        if (constraints.maxWidth >= 800) {
          return const HomeDesktopScreen();
        } else {
          return const HomeMobileScreen();
        }
      },
    );
  }
}
