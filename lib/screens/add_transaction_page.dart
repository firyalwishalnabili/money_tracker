import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AddTransactionPage extends StatefulWidget {
  final Transaction? transaction;

  AddTransactionPage({this.transaction});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  bool isIncome = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      titleController.text = widget.transaction!.title;
      amountController.text = widget.transaction!.amount.toString();
      isIncome = widget.transaction!.isIncome;
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submitData() {
    if (titleController.text.isEmpty || amountController.text.isEmpty) return;

    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    final newTransaction = Transaction(
      title: enteredTitle,
      amount: enteredAmount,
      date: DateTime.now(),
      isIncome: isIncome,
    );

    Navigator.of(context).pop(newTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'Add Transaction' : 'Edit Transaction'),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.description), // Icon buat judul transaksi
                ),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money), // Icon buat jumlah uang
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Outcome"),
                  Switch(
                    value: isIncome,
                    onChanged: (value) {
                      setState(() {
                        isIncome = value;
                      });
                    },
                  ),
                  Text("Income"),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(widget.transaction == null ? 'Add Transaction' : 'Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
