import 'package:flutter/material.dart';
import 'package:uangsakuku/presentation/main_screen.dart';
import 'package:uangsakuku/presentation/screens/auth/login_screen.dart';
import 'package:uangsakuku/services/auth_service.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    // Untuk Mengakses perubahan user bila sudah login maka ke mainscreen
    return StreamBuilder(
      stream: Auth().authStatechanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const AuthPage();
      },
    );
  }
}
