import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/add_expense_overlay.dart';
import 'package:expenses_tracker/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/widgets/expenses_list_view.dart';
import 'package:flutter/widgets.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreen();
}

class _ExpensesScreen extends State<ExpensesScreen> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'traveling',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: 'Flutter Course',
      amount: 120.366,
      date: DateTime.now(),
      category: Category.work,
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(int index) {
    final temp = _registeredExpenses[index];
    setState(() {
      _registeredExpenses.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text('${temp.title} Deleted!'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(index, temp);
            });
          },
        ),
      ),
    );
  }

  void _showAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => AddExpenseOverlay(onSubmit: _addExpense),
    );
  }

  Widget get mainContent {
    if (_registeredExpenses.isNotEmpty) {
      return ExpensesListView(
        expenses: _registeredExpenses,
        onDismiss: _removeExpense,
      );
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No Expenses Yet. Try adding some!',
          style: TextStyle(fontSize: 20.0, color: Colors.black87),
        ),
        SizedBox(height: 10),
        Icon(
          Icons.assignment_outlined,
          size: 100.0,
          color: Colors.black45,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Expense Tracker',
        ),
        actions: [
          IconButton(
            onPressed: _showAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: screenWidth < 600.0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
