import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  // ✅ Tambahkan field uid untuk menyimpan ID user pemilik memo
  String uid;
  double amount;
  String description;
  bool isIncome;
  String category;
  Timestamp transactionDate;
  Timestamp createdAt;
  Timestamp updatedAt;

  // ✅ Tambahkan uid di constructor
  Memo({
    required this.uid,
    required this.amount,
    required this.description,
    required this.isIncome,
    required this.category,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ Tambahkan uid di copyWith
  Memo copyWith({
    String? uid, // Tambahkan
    double? amount,
    String? description,
    bool? isIncome,
    String? category,
    Timestamp? transactionDate,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Memo(
      uid: uid ?? this.uid, // Tambahkan
      amount: amount ?? this.amount,
      description: description ?? this.description,
      isIncome: isIncome ?? this.isIncome,
      category: category ?? this.category,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ✅ Tambahkan pemrosesan uid dari JSON Firebase
  Memo.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String, // Tambahkan
          amount: (json['amount'] ?? 0.0) as double,
          description: json['description']! as String,
          isIncome: json['isIncome']! as bool,
          category: json['category']! as String,
          transactionDate: json['transactionDate']! as Timestamp,
          createdAt: json['createdAt']! as Timestamp,
          updatedAt: json['updatedAt']! as Timestamp,
        );

  // ✅ Sertakan uid saat konversi ke JSON untuk dikirim ke Firebase
  Map<String, Object?> toJson() {
    return {
      'uid': uid, // Tambahkan
      'amount': amount,
      'description': description,
      'isIncome': isIncome,
      'category': category,
      'transactionDate': transactionDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
