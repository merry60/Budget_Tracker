import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/categories.dart';
import '../utils/notification_helper.dart';
import '../widgets/category_chip.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? existingExpense;
  const AddExpenseScreen({super.key, this.existingExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingExpense != null) {
      _amountController.text = widget.existingExpense!.amount.toStringAsFixed(
        0,
      );
      _noteController.text = widget.existingExpense!.note;
      _selectedDate = widget.existingExpense!.date;

      try {
        _selectedCategory = {
          'name': widget.existingExpense!.category,
          'emoji': widget.existingExpense!.categoryEmoji,
        };
      } catch (e) {
        _selectedCategory = pakCategories.first;
      }
    }
  }

  void _showAddCategoryDialog(BuildContext context, ExpenseProvider provider) {
    final nameController = TextEditingController();
    final emojiController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name (e.g. Gym)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emojiController,
              decoration: const InputDecoration(labelText: 'Emoji (e.g. 🏋️)'),
              maxLength: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final emoji = emojiController.text.trim();
              if (name.isNotEmpty && emoji.isNotEmpty) {
                provider.addCustomCategory(name, emoji);
                setState(() {
                  _selectedCategory = {'name': name, 'emoji': emoji};
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final amount = double.parse(_amountController.text);
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      final expense = Expense(
        id: widget.existingExpense?.id ?? DateTime.now().toString(),
        amount: amount,
        category: _selectedCategory!['name'],
        categoryEmoji: _selectedCategory!['emoji'],
        note: _noteController.text,
        date: _selectedDate,
      );

      final provider = context.read<ExpenseProvider>();

      // Check if this expense exceeds the budget (only if not editing or if new amount is greater)
      double amountDiff = widget.existingExpense != null
          ? amount - widget.existingExpense!.amount
          : amount;

      if (provider.totalSpentThisMonth + amountDiff > provider.monthlyBudget) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot save expense: Exceeds monthly budget!'),
            backgroundColor: Colors.red,
          ),
        );
        NotificationHelper.showBudgetAlert(
          provider.totalSpentThisMonth + amountDiff,
          provider.monthlyBudget,
        );
        return;
      }

      if (widget.existingExpense != null) {
        provider.updateExpense(widget.existingExpense!, expense);
      } else {
        provider.addExpense(expense);
      }

      if (provider.totalSpentThisMonth > provider.monthlyBudget * 0.9) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are close to your budget limit!'),
            backgroundColor: Colors.orange,
          ),
        );
        NotificationHelper.showBudgetAlert(
          provider.totalSpentThisMonth,
          provider.monthlyBudget,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingExpense != null ? 'Edit Expense' : 'Add Expense',
        ),
        actions: [
          if (widget.existingExpense != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Expense'),
                    content: const Text(
                      'Are you sure you want to delete this expense?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ExpenseProvider>().deleteExpense(
                            widget.existingExpense!.id,
                          );
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Close edit screen
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'Rs. ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Consumer<ExpenseProvider>(
                builder: (context, provider, child) {
                  final allCategories = [
                    ...pakCategories,
                    ...provider.customCategories,
                  ];
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...allCategories.map((cat) {
                        return CategoryChip(
                          category: cat,
                          isSelected:
                              _selectedCategory != null &&
                              _selectedCategory!['name'] == cat['name'],
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        );
                      }),
                      CategoryChip(
                        category: const {'name': 'New', 'emoji': '➕'},
                        isSelected: false,
                        onTap: () => _showAddCategoryDialog(context, provider),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickDate,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.existingExpense != null
                      ? 'Update Expense'
                      : 'Save Expense',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
