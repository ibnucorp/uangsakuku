import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  bool isIncome;

  Category({
    required this.name,
    required this.isIncome,
  });

// Fungsi untuk mempermudah update data
  Category copyWith({
    String? name,
    bool? isIncome,
  }) {
    return Category(
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  // Untuk Mengkonversi Data json dari firebase
  Category.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          isIncome: json['isIncome']! as bool,
        );

  // Untuk mengkonversi format data flutter ke json untuk firebase
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'isIncome': isIncome,
    };
  }
}
