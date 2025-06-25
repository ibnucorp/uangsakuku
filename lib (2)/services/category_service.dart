import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Untuk akses UID user
import 'package:uangsakuku/models/category_model.dart';

const String CATEGORY_COLLECTION_REF = 'categories';

class CategoryService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Koleksi dengan konverter model Category
  late final CollectionReference<Category> _categoryRef;

  CategoryService() {
    _categoryRef = _firestore
        .collection(CATEGORY_COLLECTION_REF)
        .withConverter<Category>(
          fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        );
  }

  /// ✅ Ambil kategori yang hanya milik user yang login
  Stream<QuerySnapshot<Category>> getCategories(String uid) {
    return _categoryRef
        .where('uid', isEqualTo: uid) // hanya data yang cocok dengan uid
        .snapshots();
  }

  /// ✅ Tambah kategori ke Firestore dan sertakan UID user
  Future<void> addCategory(Category category) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      // Konversi data dan sisipkan uid
      final data = category.toJson();
      data['uid'] = uid;

      // Simpan data langsung ke koleksi (tanpa withConverter)
      await _firestore.collection(CATEGORY_COLLECTION_REF).add(data);
    }
  }

  /// Update kategori berdasarkan ID
  Future<void> updateCategory(String categoryId, Category category) async {
    await _categoryRef.doc(categoryId).update(category.toJson());
  }

  /// Hapus kategori berdasarkan ID
  Future<void> deleteCategory(String categoryId) async {
    await _categoryRef.doc(categoryId).delete();
  }
}
