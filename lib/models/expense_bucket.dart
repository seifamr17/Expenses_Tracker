import 'expense.dart';

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get sum {
    double sum = 0;
    for (final Expense expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
