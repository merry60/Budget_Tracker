import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../utils/constants.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Map<String, dynamic>> customCategories = [];
  double monthlyBudget = 0.0;
  bool isDarkMode = false;

  // Getters
  List<Expense> get expenses => _expenses;

  double get totalSpentThisMonth {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get remainingBudget => monthlyBudget - totalSpentThisMonth;

  Map<String, double> get expensesByCategory {
    final now = DateTime.now();
    Map<String, double> data = {};
    for (var e in _expenses) {
      if (e.date.year == now.year && e.date.month == now.month) {
        data[e.category] = (data[e.category] ?? 0.0) + e.amount;
      }
    }
    return data;
  }

  Map<String, double> get expensesByMonth {
    // Return last 6 months spending
    Map<String, double> data = {};
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      String name = _monthName(month.month);
      data[name] = 0.0;
    }
    for (var e in _expenses) {
      if (e.date.isAfter(DateTime(now.year, now.month - 5, 1))) {
        String name = _monthName(e.date.month);
        if (data.containsKey(name)) {
          data[name] = data[name]! + e.amount;
        }
      }
    }
    return data;
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // Load data from Hive and SharedPreferences
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    monthlyBudget = prefs.getDouble(kBudgetKey) ?? 0.0;
    isDarkMode = prefs.getBool(kThemeKey) ?? false;

    final customCatsStrs = prefs.getStringList('custom_categories') ?? [];
    customCategories = customCatsStrs
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList();

    try {
      final box = Hive.box<Expense>('expenses');
      _expenses = box.values.toList();

      // Sort youngest first
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print("Error loading Hive data: $e");
    }

    notifyListeners();
  }

  // Add expense
  Future<void> addExpense(Expense e) async {
    final box = Hive.box<Expense>('expenses');
    await box.add(e);
    _expenses.add(e);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  // Update expense
  Future<void> updateExpense(Expense oldExpense, Expense newExpense) async {
    final box = Hive.box<Expense>('expenses');
    await box.put(oldExpense.key, newExpense);

    final index = _expenses.indexWhere((e) => e.id == oldExpense.id);
    if (index != -1) {
      _expenses[index] = newExpense;
    }

    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    final expenseToRemove = _expenses.firstWhere((e) => e.id == id);
    await expenseToRemove.delete(); // HiveObject makes this easy
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Set budget
  Future<void> setBudget(double amount) async {
    monthlyBudget = amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(kBudgetKey, amount);
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kThemeKey, isDarkMode);
    notifyListeners();
  }

  // Add Custom Category
  Future<void> addCustomCategory(String name, String emoji) async {
    final newCat = {'name': name, 'emoji': emoji};
    customCategories.add(newCat);
    final prefs = await SharedPreferences.getInstance();
    final strs = customCategories.map((c) => jsonEncode(c)).toList();
    await prefs.setStringList('custom_categories', strs);
    notifyListeners();
  }
}
