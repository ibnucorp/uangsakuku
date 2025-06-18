import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uangsakuku/firebase_options.dart';
import 'package:uangsakuku/presentation/main_screen.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
