import 'package:firebase_auth/firebase_auth.dart';
import 'package:uangsakuku/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AuthPage> {
  String? errorMessage = '';
  bool isLoginPage = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    // Memanggil fungsi login di class Auth
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    // Memanggil fungsi register dari class Auth
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text(
      "UangSakuKu",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(labelText: title),
      controller: controller,
      obscureText: title == 'Password' ? true : false,
    );
  }

  Widget _errorMessage() {
    // fungsi untuk cek isi errorMessage
    return Text(errorMessage == '' ? '' : 'Error: $errorMessage');
  }

  Widget _submitButton() {
    // menjalankan fungsi dengan cek kondisi isLoginPage
    return ElevatedButton(
        onPressed: isLoginPage
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(isLoginPage ? 'Login' : 'Register'));
  }

  // Tombol untuk mengubah kondisi isLoginPage
  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLoginPage = !isLoginPage;
        });
      },
      child: Text(isLoginPage
          ? "Belum punya akun? Daftar disini."
          : "Sudah punya akun? Login disini"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.all(16.0),
          height: 300,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_title()],
              ),
              _errorMessage(),
              SizedBox(
                height: 10.0,
              ),
              _entryField('Email', _emailController),
              SizedBox(
                height: 10.0,
              ),
              _entryField('Password', _passwordController),
              SizedBox(
                height: 10.0,
              ),
              _submitButton(),
              _loginOrRegisterButton()
            ],
          ),
        ),
      ),
    );
  }
}
