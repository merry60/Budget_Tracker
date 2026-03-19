import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  }

  List<String> _getLast6Months() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 6; i++) {
      months.add(
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - i, 1)),
      );
    }
    return months;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              items: _getLast6Months().map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                final allExpenses = provider.expenses;
                final filteredExpenses = allExpenses.where((e) {
                  return DateFormat('MMMM yyyy').format(e.date) ==
                      _selectedMonth;
                }).toList();

                if (filteredExpenses.isEmpty) {
                  return const Center(
                    child: Text(
                      'No expenses for this month',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return Dismissible(
                      key: Key(expense.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        provider.deleteExpense(expense.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Expense deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                provider.addExpense(expense); // Simple undo
                              },
                            ),
                          ),
                        );
                      },
                      child: ExpenseCard(expense: expense),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
