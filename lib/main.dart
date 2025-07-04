import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uangsakuku/firebase_options.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
      theme: CustomTheme.lightThemeData(context),
    );
  }
}

class CustomTheme {
  // Tema kustom
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            surface: Colors.white,
            error: Colors.red,
            onTertiary: Colors.orange));
  }

  static ThemeData darkThemeData() {
    return ThemeData(useMaterial3: true);
  }
}
