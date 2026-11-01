import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'scenes/login/login_factory.dart';

void main() {
  runApp(const FindriveApp());
}

class FindriveApp extends StatelessWidget {
  const FindriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FINDRIVE — Copiloto Financeiro do Motorista',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: LoginFactory.make(),
    );
  }
}
