class Transaction {
  final String title; // Nama transaksi
  final double amount; // Jumlah uang transaksi
  final DateTime date; // Tanggal transaksi
  final bool isIncome; // True buat income, false buat outcome

  // Konstruktor buat bikin objek transaksi baru
  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
