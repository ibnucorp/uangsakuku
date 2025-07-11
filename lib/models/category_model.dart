class Category {
  String uid;
  String name;
  bool isIncome;

  Category({
    required this.uid,
    required this.name,
    required this.isIncome,
  });

// Fungsi untuk mempermudah update data
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

  // Untuk Mengkonversi Data json dari firebase
  Category.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          name: json['name']! as String,
          isIncome: json['isIncome']! as bool,
        );

  // Untuk mengkonversi format data flutter ke json untuk firebase
  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'isIncome': isIncome,
    };
  }
}
