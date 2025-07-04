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
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: Colors.black54),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      controller: controller,
      obscureText: title == 'Password' ? true : false,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _errorMessage() {
    // fungsi untuk cek isi errorMessage
    return Text(
      errorMessage == '' ? '' : 'Error: $errorMessage',
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    // menjalankan fungsi dengan cek kondisi isLoginPage
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: isLoginPage
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(
          isLoginPage ? 'LOGIN' : 'REGISTER',
          style: TextStyle(fontSize: 16, letterSpacing: 1),
        ),
      ),
    );
  }

  // Tombol untuk mengubah kondisi isLoginPage
  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLoginPage = !isLoginPage;
        });
      },
      child: Text(
        isLoginPage
            ? "Belum punya akun? Daftar disini."
            : "Sudah punya akun? Login disini",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade400,
              )),
          padding: EdgeInsets.all(32.0),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UangSakuKu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 32),
              _entryField('Email', _emailController),
              SizedBox(height: 24),
              _entryField('Password', _passwordController),
              SizedBox(height: 8),
              _errorMessage(),
              SizedBox(height: 32),
              _submitButton(),
              SizedBox(height: 16),
              Center(child: _loginOrRegisterButton()),
            ],
          ),
        ),
      ),
    );
  }
}
