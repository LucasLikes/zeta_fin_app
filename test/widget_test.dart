

import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/routes/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'ZetaFin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
