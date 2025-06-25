import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  // ✅ Tambahkan field uid untuk menyimpan ID user pemilik kategori
  String uid;
  String name;
  bool isIncome;

  // ✅ Tambahkan uid di constructor
  Category({
    required this.uid,
    required this.name,
    required this.isIncome,
  });

  // ✅ Tambahkan uid di copyWith
  Category copyWith({
    String? uid,
    String? name,
    bool? isIncome,
  }) {
    return Category(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  // ✅ Tambahkan pemrosesan uid dari JSON Firebase
  Category.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          name: json['name']! as String,
          isIncome: json['isIncome']! as bool,
        );

  // ✅ Sertakan uid saat konversi ke JSON untuk dikirim ke Firestore
  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'isIncome': isIncome,
    };
  }
}
