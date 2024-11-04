import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'add_transaction_page.dart';

class HomePage extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) addTransaction;
  final Function(int, Transaction) updateTransaction;
  final Function(int) deleteTransaction;
  final double totalIncome;
  final double totalOutcome;
  final double balance;

  HomePage({
    required this.transactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.totalIncome,
    required this.totalOutcome,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Rata tengah
          children: [
            Icon(
              Icons.monetization_on_outlined,
              color: Colors.blue,
            ), // Ikon uang
            SizedBox(width: 5), // Spasi antara ikon dan teks
            Text(
              'Money Tracker',
              style: TextStyle(
                fontSize: 24, // Mengubah ukuran font
                fontWeight: FontWeight.bold, // Mengubah ketebalan font
                color: Colors.blue, // Mengubah warna teks
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 35),
          // Widget untuk menampilkan saldo, income, dan outcome
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // Container untuk ikon
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0), // Jarak antara ikon dan teks
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.blue,
                        size: 40, // Mengubah ukuran ikon menjadi lebih besar
                      ),
                    ),
                    // Container untuk teks "Balance"
                    Container(
                      margin: const EdgeInsets.only(bottom: 4.0), // Jarak antara "Balance" dan jumlah
                      child: Text(
                        "Balance",
                        style: TextStyle(
                          fontSize: 18, // Mengubah ukuran font
                          fontWeight: FontWeight.bold, // Mengubah ketebalan font
                          color: Colors.blue, // Mengubah warna teks
                        ),
                      ),
                    ),
                    // Container untuk jumlah balance
                    Text(
                      "\$${balance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24, // Mengubah ukuran font menjadi lebih besar
                        fontWeight: FontWeight.bold, // Mengubah ketebalan font
                        color: Colors.black, // Mengubah warna teks
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.arrow_circle_up, color: Colors.green, size: 30), // Ikon untuk income
                    Text("Income", style: TextStyle(color: Colors.green)),
                    Text("\$${totalIncome.toStringAsFixed(2)}"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.arrow_circle_down, color: Colors.red, size: 30), // Ikon untuk outcome
                    Text("Outcome", style: TextStyle(color: Colors.red)),
                    Text("\$${totalOutcome.toStringAsFixed(2)}"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0), // Menambahkan padding di sekitar ListView
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Container(
                  padding: EdgeInsets.all(10.0), // Menambahkan padding di sekitar item
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0), // Menambahkan margin antar item
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // Mengubah latar belakang item menjadi abu-abu muda
                    borderRadius: BorderRadius.circular(8.0), // Membuat sudut melengkung
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Bayangan
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Posisi bayangan
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      tx.isIncome ? Icons.attach_money : Icons.money_off, // Ikon untuk bedain income & outcome
                      color: tx.isIncome ? Colors.green : Colors.red,
                    ),
                    title: Text(tx.title, style: TextStyle(fontWeight: FontWeight.bold)), // Nama transaksi
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tx.date.toLocal()}', // Tanggal transaksi
                          style: TextStyle(
                            color: Colors.grey, // Mengubah warna tanggal menjadi abu-abu
                            fontSize: 10, // Mengubah ukuran font tanggal
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${tx.amount.toStringAsFixed(2)}', // Jumlah transaksi
                          style: TextStyle(
                            color: tx.isIncome ? Colors.green : Colors.red, // Warna sesuai tipe transaksi
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black), // Tombol delete
                          onPressed: () {
                            // Konfirmasi hapus transaksi
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Delete Transaction?'),
                                content: Text('Are you sure you want to delete this transaction?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      deleteTransaction(index);
                                      Navigator.of(ctx).pop(); // Menutup dialog
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(); // Menutup dialog
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () async {
                      // Navigasi ke halaman edit
                      final updatedTransaction = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTransactionPage(transaction: tx),
                        ),
                      );
                      if (updatedTransaction != null && updatedTransaction is Transaction) {
                        updateTransaction(index, updatedTransaction); // Update transaksi jika ada perubahan
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Animasi saat nambah transaksi baru
          final newTransaction = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(),
            ),
          );
          if (newTransaction != null && newTransaction is Transaction) {
            addTransaction(newTransaction);
          }
        },
        child: Icon(Icons.add, color: Colors.white), // Ikon tombol tambah
        backgroundColor: Colors.blue, // Mengubah warna latar belakang tombol
      ),
    );
  }
}
