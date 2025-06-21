import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // inisialisasi firebase auth server
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // getter user
  User? get currentUser => _firebaseAuth.currentUser;

  // mendeteksi perubahan pada user
  Stream<User?> get authStatechanges => _firebaseAuth.authStateChanges();

  // Fungsi untuk login dengan fungsi bawaan firebase auth
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Fungsi untuk register
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Fungsi untuk logout
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
