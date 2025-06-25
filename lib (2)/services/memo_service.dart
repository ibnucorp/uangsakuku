import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uangsakuku/models/memo_model.dart';

const String MEMO_COLLECTION_REF = 'memos';

class MemoService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late final CollectionReference<Memo> _memoRef;

  MemoService() {
    _memoRef = _firestore.collection(MEMO_COLLECTION_REF).withConverter<Memo>(
          fromFirestore: (snapshot, _) => Memo.fromJson(snapshot.data()!),
          toFirestore: (memo, _) => memo.toJson(),
        );
  }

  /// ✅ Ambil semua memo milik user yang sedang login
  Stream<QuerySnapshot<Memo>> getMemos() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _memoRef
        .where('uid', isEqualTo: uid)
        .orderBy('transactionDate', descending: true)
        .snapshots();
  }

  /// ✅ Tambah memo dan sematkan UID user yang sedang login
  Future<void> addMemo(Memo memo) async {
    await _memoRef.add(memo);
  }

  /// ✅ Update memo berdasarkan ID
  Future<void> updateMemo(String memoId, Memo memo) async {
    await _memoRef.doc(memoId).update(memo.toJson());
  }

  /// ✅ Hapus memo berdasarkan ID
  Future<void> deleteMemo(String memoId) async {
    await _memoRef.doc(memoId).delete();
  }
}
