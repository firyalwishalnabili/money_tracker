import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
    // Calculate total and percentage of outcomes by category
    Map<String, double> categoryData = {};
    for (var tx in transactions) {
      if (!tx.isIncome) {
        categoryData[tx.category ?? 'Uncategorized'] =
            (categoryData[tx.category ?? 'Uncategorized'] ?? 0) + tx.amount;

        String formattedDate = '${tx.date.toLocal()}'; // Format tanggal sesuai kebutuhan
      }
    }

    double totalCategoryOutcome = categoryData.values.fold(0, (a, b) => a + b);

    List<PieChartSectionData> sections = categoryData.entries.map((entry) {
      Color sectionColor;

      // Assign different colors based on the category
      switch (entry.key) {
        case 'Food and Beverages':
          sectionColor = Colors.red;
          break;
        case 'Transportation':
          sectionColor = Colors.blue;
          break;
        case 'Bills and Utilities':
          sectionColor = Colors.green;
          break;
        case 'Health':
          sectionColor = Colors.orange;
          break;
        case 'Entertainment':
          sectionColor = Colors.purple;
          break;
        case 'Education':
          sectionColor = Colors.teal;
          break;
        case 'Investment':
          sectionColor = Colors.amber;
          break;
        case 'Others':
          sectionColor = Colors.grey;
          break;
        default:
          sectionColor = Colors.black; // Default color for uncategorized
      }

      return PieChartSectionData(
        color: sectionColor,
        value: entry.value,
        title: '', // Empty title to hide text
        radius: 30,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.monetization_on_outlined,
              color: Colors.blue,
            ),
            SizedBox(width: 5),
            Text(
              'Money Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.blue,
                          size: 60,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "Balance",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Text(
                        "\$${balance.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                      Icon(Icons.arrow_circle_up, color: Colors.green, size: 30),
                      Text("Income", style: TextStyle(color: Colors.green)),
                      Text("\$${totalIncome.toStringAsFixed(2)}"),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.arrow_circle_down, color: Colors.red, size: 30),
                      Text("Outcome", style: TextStyle(color: Colors.red)),
                      Text("\$${totalOutcome.toStringAsFixed(2)}"),
                    ],
                  ),
                ],
              ),
            ),
            // Text "Outcome Detail :"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Outcome Detail :",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            // Chart Percentage Outcome
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200, // Height of the chart
                child: totalCategoryOutcome > 0 ? PieChart(
                  PieChartData(
                    sections: sections,
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 40,
                  ),
                ) : Center(
                  child: Text(
                    "Outcome transaction not available",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // Color legend for categories
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan semua kategori
                children: categoryData.entries.map((entry) {
                  double percentage = (entry.value / totalCategoryOutcome) * 100;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0), // Padding vertikal untuk jarak antar kategori
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Pusatkan setiap kategori
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: entry.key == 'Food and Beverages' ? Colors.red :
                          entry.key == 'Transportation' ? Colors.blue :
                          entry.key == 'Bills and Utilities' ? Colors.green :
                          entry.key == 'Health' ? Colors.orange :
                          entry.key == 'Entertainment' ? Colors.purple :
                          entry.key == 'Education' ? Colors.teal :
                          entry.key == 'Investment' ? Colors.amber :
                          entry.key == 'Others' ? Colors.grey : Colors.black,
                        ),
                        SizedBox(width: 8), // Jarak antara kotak warna dan teks
                        Text(
                          '${entry.key}: ${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            // Transaction list
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true, // Avoid overflow
                physics: NeverScrollableScrollPhysics(), // Disable scrolling on ListView
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        tx.isIncome ? Icons.attach_money : Icons.money_off,
                        color: tx.isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(tx.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${tx.date.toLocal()}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          if (!tx.isIncome && tx.category != null)
                            Text(
                              'Category: ${tx.category}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: tx.isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Delete Transaction?'),
                                  content: Text('Are you sure you want to delete this transaction?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteTransaction(index);
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
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
                        final updatedTransaction = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTransactionPage(transaction: tx),
                          ),
                        );
                        if (updatedTransaction != null && updatedTransaction is Transaction) {
                          updateTransaction(index, updatedTransaction);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}