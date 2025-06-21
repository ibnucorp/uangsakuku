import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uangsakuku/firebase_options.dart';
import 'package:uangsakuku/presentation/main_screen.dart';
import 'package:uangsakuku/widget_tree.dart';

void main() async {
  Intl.defaultLocale = 'id_ID';
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
