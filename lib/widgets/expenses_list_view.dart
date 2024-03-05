import 'package:expenses_tracker/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';

class ExpensesListView extends StatelessWidget {
  const ExpensesListView({
    super.key,
    required this.expenses,
    required this.onDismiss,
  });

  final Function onDismiss;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: Theme.of(context).cardTheme.margin,
        ),
        onDismissed: (direction) {
          onDismiss(index);
        },
        child: ExpenseCard(expenses[index]),
      ),
      itemCount: expenses.length,
    );
  }
}
