import 'package:flutter/material.dart';
import 'package:uangsakuku/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth authService = Auth();
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  authService.signOut();
                },
                child: Text("Log Out"))
          ],
        ),
      ),
    ));
  }
}
