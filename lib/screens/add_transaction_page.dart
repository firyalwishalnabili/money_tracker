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
  String? selectedCategory;
  late AnimationController _controller;
  late Animation<double> _animation;

  // Listnyah
  final List<String> categories = [
    'Food and Beverages',
    'Transportation',
    'Bills and Utilities',
    'Health',
    'Entertainment',
    'Education',
    'Investment',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      titleController.text = widget.transaction!.title;
      amountController.text = widget.transaction!.amount.toString();
      isIncome = widget.transaction!.isIncome;
      selectedCategory = widget.transaction!.category;
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
    final String id = DateTime.now().toString(); // Generate a unique ID

    final newTransaction = Transaction(
      id: id,
      title: enteredTitle,
      amount: enteredAmount,
      date: DateTime.now(),
      isIncome: isIncome,
      category: isIncome ? null : selectedCategory,
    );

    Navigator.of(context).pop(newTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.description),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixIcon: Icon(Icons.attach_money),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                ),
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
                        selectedCategory = null;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red[200],
                  ),
                  Text("Income"),
                ],
              ),
              // Dropdown si category
              if (!isIncome) ...[
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 300,
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: Text("Select Category"),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 25),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 175,
                  child: ElevatedButton(
                    onPressed: _submitData,
                    child: Text(
                      widget.transaction == null ? 'Add Transaction' : 'Update Transaction',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}