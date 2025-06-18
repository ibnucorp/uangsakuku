import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uangsakuku/models/category_model.dart';

// Nama Database di firebase
const String CATEGORY_COLLECTION_REF = 'categories';

class CategoryService {
  // inisialisasi Firestore
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _categoryRef;

  // Untuk mengisi _categoryRef dengan Collection dari firestore
  CategoryService() {
    _categoryRef = _firestore
        .collection(CATEGORY_COLLECTION_REF)
        .withConverter<Category>(
            fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
            toFirestore: (category, _) => category.toJson());
  }

  // Fungsi untuk mengembalikan isi dari Memos
  Stream<QuerySnapshot> getCategories() {
    return _categoryRef.snapshots();
  }

// Fungsi untuk menambah category
  void addCategory(Category category) {
    _categoryRef.add(category);
  }

// Fungsi untuk mengubah data sebuah category
  void updateCategory(String categoryId, Category category) {
    _categoryRef.doc(categoryId).update(category.toJson());
  }

// Fungsi untuk menghapus category
  void deleteCategory(String categoryId) {
    _categoryRef.doc(categoryId).delete();
  }
}
