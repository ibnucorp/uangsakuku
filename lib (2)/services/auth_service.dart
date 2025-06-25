import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Tambahkan Firestore

class Auth {
  // Inisialisasi Firebase Auth dan Firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ✅ Tambahan

  // Getter user saat ini
  User? get currentUser => _firebaseAuth.currentUser;

  // Deteksi perubahan status login/logout
  Stream<User?> get authStatechanges => _firebaseAuth.authStateChanges();

  // ✅ Fungsi Login: menggunakan email dan password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ✅ Fungsi Register: sekaligus menyimpan data user ke koleksi Firestore
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Buat akun user di Firebase Auth
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    // ✅ Setelah berhasil, simpan data user ke koleksi "users"
    User? user = userCredential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return userCredential;
  }

  // Fungsi Logout
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
