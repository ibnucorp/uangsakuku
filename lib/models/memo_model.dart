import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  double amount;
  String description;
  bool isIncome;
  String category;
  Timestamp transactionDate;
  Timestamp createdAt;
  Timestamp updatedAt;

  Memo({
    required this.amount,
    required this.description,
    required this.isIncome,
    required this.category,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

// Fungsi untuk mempermudah update data
  Memo copyWith({
    double? amount,
    String? description,
    bool? isIncome,
    String? category,
    Timestamp? transactionDate,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Memo(
        amount: amount ?? this.amount,
        description: description ?? this.description,
        isIncome: isIncome ?? this.isIncome,
        category: category ?? this.category,
        transactionDate: transactionDate ?? this.transactionDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  // Untuk Mengkonversi Data json dari firebase
  Memo.fromJson(Map<String, Object?> json)
      : this(
          amount: (json['amount'] ?? 0.0) as double,
          description: json['description']! as String,
          isIncome: json['isIncome']! as bool,
          category: json['category']! as String,
          transactionDate: json['transactionDate']! as Timestamp,
          createdAt: json['createdAt']! as Timestamp,
          updatedAt: json['updatedAt']! as Timestamp,
        );

  // Untuk mengkonversi format data flutter ke json untuk firebase
  Map<String, Object?> toJson() {
    return {
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
