import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uangsakuku/models/memo_model.dart';

// Nama Database di firebase
const String MEMO_COLLECTION_REF = 'memos';

class MemoService {
  // inisialisasi Firestore
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _memoRef;

  // Untuk mengisi _memoRef dengan Collection dari firestore
  MemoService() {
    _memoRef = _firestore.collection(MEMO_COLLECTION_REF).withConverter<Memo>(
        fromFirestore: (snapshot, _) => Memo.fromJson(snapshot.data()!),
        toFirestore: (memo, _) => memo.toJson());
  }

  // Fungsi untuk mengembalikan isi dari Memos
  Stream<QuerySnapshot> getMemos() {
    return _memoRef.orderBy('transactionDate', descending: true).snapshots();
  }

// Fungsi untuk menambah memo
  void addMemo(Memo memo) {
    _memoRef.add(memo);
  }

// Fungsi untuk mengubah data sebuah memo
  void updateMemo(String memoId, Memo memo) {
    _memoRef.doc(memoId).update(memo.toJson());
  }

// Fungsi untuk menghapus memo
  void deleteMemo(String memoId) {
    _memoRef.doc(memoId).delete();
  }
}
