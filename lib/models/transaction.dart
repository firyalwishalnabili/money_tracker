class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final String? category; // Tambahkan kategori sebagai nullable
  final DateTime date; // Tambahkan tanggal

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    this.category, // Kategori bisa null
    DateTime? date, // Tanggal bisa null
  }) : this.date = date ?? DateTime.now(); // Jika tidak ada tanggal, gunakan tanggal sekarang

  // Mengonversi objek Transaction ke Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'date': date.toIso8601String(), // Simpan tanggal dalam format ISO 8601
    };
  }

  // Mengonversi Map ke objek Transaction
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      isIncome: json['isIncome'],
      category: json['category'],
      date: DateTime.parse(json['date']), // Parsing tanggal dari string
    );
  }
}