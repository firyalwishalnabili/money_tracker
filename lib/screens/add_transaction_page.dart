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

  // List of expense categories in English
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
      selectedCategory = widget.transaction!.category; // Set category if available
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
      category: isIncome ? null : selectedCategory, // Only assign category if outcome
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
                alignment: Alignment.center, // Center the TextField
                child: SizedBox(
                  width: 300, // Set TextField width
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0), // Margin between fields
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.description),
                        filled: true,
                        fillColor: Colors.grey[200], // Background color of TextField
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Padding inside TextField
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center, // Center the TextField
                child: SizedBox(
                  width: 300, // Set TextField width
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0), // Margin between fields
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixIcon: Icon(Icons.attach_money),
                        filled: true,
                        fillColor: Colors.grey[200], // Background color of TextField
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Padding inside TextField
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
                        selectedCategory = null; // Reset category when income is selected
                      });
                    },
                    activeColor: Colors.green, // Color of switch when active
                    inactiveThumbColor: Colors.red, // Color of thumb when inactive
                    inactiveTrackColor: Colors.red[200], // Color of track when inactive
                  ),
                  Text("Income"),
                ],
              ),
              // Dropdown to select category, only appears if outcome
              if (!isIncome) ...[
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center, // Center the dropdown
                  child: Container(
                    width: 300, // Set dropdown width
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
                alignment: Alignment.center, // Center the button
                child: SizedBox(
                  width: 175, // Set button width
                  child: ElevatedButton(
                    onPressed: _submitData,
                    child: Text(
                      widget.transaction == null ? 'Add Transaction' : 'Update Transaction',
                      style: TextStyle(
                        fontSize: 14, // Smaller font size
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