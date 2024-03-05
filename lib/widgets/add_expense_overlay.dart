import 'package:expenses_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddExpenseOverlay extends StatefulWidget {
  const AddExpenseOverlay({super.key, required this.onSubmit});
  final void Function(Expense) onSubmit;

  @override
  State<AddExpenseOverlay> createState() => _AddExpenseOverlayState();
}

class _AddExpenseOverlayState extends State<AddExpenseOverlay> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.leisure;

  String? _titleErrorText;
  String? _amountErrorText;

  void _showDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );

    if (date == null) {
      return;
    }
    setState(() {
      _selectedDate = date;
    });
  }

  void _submitForm() {
    bool invalid = false;
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        _titleErrorText = 'Expense title cannot be empty';
      });
      invalid = true;
    } else {
      setState(() {
        _titleErrorText = null;
      });
    }

    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _amountErrorText = 'Amount must be a positive number';
      });
      invalid = true;
    } else {
      setState(() {
        _amountErrorText = null;
      });
    }

    if (invalid) return;

    final Expense expense = Expense(
      title: _titleController.text,
      amount: amount!,
      date: _selectedDate,
      category: _selectedCategory,
    );

    widget.onSubmit(expense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardHeight + 16),
          child: Column(
            children: [
              TextField(
                maxLength: 50,
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  label: const Text('Title'),
                  errorText: _titleErrorText,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Amount'),
                        prefixText: '\$ ',
                        errorText: _amountErrorText,
                        errorMaxLines: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Expense.formatter.format(_selectedDate),
                        ),
                        IconButton(
                          onPressed: _showDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Save Expense'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
