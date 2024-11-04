import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MoneyTrackerApp());
}

class MoneyTrackerApp extends StatefulWidget {
  @override
  _MoneyTrackerAppState createState() => _MoneyTrackerAppState();
}

class _MoneyTrackerAppState extends State<MoneyTrackerApp> {
  final List<Transaction> _transactions = [];

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.add(transaction);
    });
  }

  void _updateTransaction(int index, Transaction updatedTransaction) {
    setState(() {
      _transactions[index] = updatedTransaction;
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  double get totalIncome => _transactions
      .where((tx) => tx.isIncome)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get totalOutcome => _transactions
      .where((tx) => !tx.isIncome)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get balance => totalIncome - totalOutcome;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.amber, // Warna aksen baru
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        transactions: _transactions,
        addTransaction: _addTransaction,
        updateTransaction: _updateTransaction,
        deleteTransaction: _deleteTransaction,
        totalIncome: totalIncome,
        totalOutcome: totalOutcome,
        balance: balance,
      ),
    );
  }
}
