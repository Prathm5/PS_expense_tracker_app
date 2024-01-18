import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class TransactionModel extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}

class AddTransactionScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Get values from text controllers
                String title = titleController.text;
                double amount = double.tryParse(amountController.text) ?? 0.0;
                String category = categoryController.text;

                // Validate and add the transaction
                if (title.isNotEmpty && amount > 0) {
                  Transaction transaction = Transaction(
                    title: title,
                    amount: amount,
                    date: DateTime.now(),
                    category: category,
                  );

                  Provider.of<TransactionModel>(context, listen: false)
                      .addTransaction(transaction);

                  // Navigate back to the HomeScreen
                  Navigator.pop(context);
                } else {
                  // Show an error message or handle invalid input
                  // For simplicity, we'll just print an error to the console
                  if (kDebugMode) {
                    print('Invalid input. Please fill in all fields.');
                  }
                }
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionModel(),
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: const TransactionList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddTransactionScreen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionModel>(context).transactions;

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction.title),
          subtitle: Text('\$${transaction.amount.toString()}'),
        );
      },
    );
  }
}
