import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString('transactions');

    if (transactionsJson != null) {
      final List<dynamic> decodedList = json.decode(transactionsJson);
      setState(() {
        _transactions = decodedList.map((json) => Transaction.fromJson(json)).toList();
      });
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String transactionsJson = json.encode(_transactions.map((tx) => tx.toJson()).toList());
    await prefs.setString('transactions', transactionsJson);
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.add(transaction);
      _saveTransactions();
    });
  }

  void _updateTransaction(int index, Transaction updatedTransaction) {
    setState(() {
      _transactions[index] = updatedTransaction;
      _saveTransactions();
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
      _saveTransactions();
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
          secondary: Colors.amber,
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
