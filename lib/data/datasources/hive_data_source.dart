import 'package:hive/hive.dart';
import 'package:fintrack/data/models/transaction_hive_model.dart';
import 'package:fintrack/data/models/budget_hive_model.dart';

class HiveDataSource {
  static const String transactionBoxName = 'transactions';
  static const String budgetBoxName = 'budgets';
  static const String settingsBoxName = 'settings';

  Box<TransactionHiveModel>? _transactionBox;
  Box<BudgetHiveModel>? _budgetBox;
  Box? _settingsBox;

  Future<void> init() async {
    _transactionBox = await Hive.openBox<TransactionHiveModel>(transactionBoxName);
    _budgetBox = await Hive.openBox<BudgetHiveModel>(budgetBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);
  }

  // Transaction operations
  Future<void> addTransaction(TransactionHiveModel transaction) async {
    await _transactionBox?.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionHiveModel transaction) async {
    await _transactionBox?.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox?.delete(id);
  }

  Future<List<TransactionHiveModel>> getAllTransactions() async {
    return _transactionBox?.values.toList() ?? [];
  }

  Future<TransactionHiveModel?> getTransaction(String id) async {
    return _transactionBox?.get(id);
  }

  Future<List<TransactionHiveModel>> getTransactionsByMonth(int month, int year) async {
    final transactions = await getAllTransactions();
    return transactions
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }

  Future<List<TransactionHiveModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final transactions = await getAllTransactions();
    return transactions
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  Future<void> clearTransactions() async {
    await _transactionBox?.clear();
  }

  // Budget operations
  Future<void> addBudget(BudgetHiveModel budget) async {
    await _budgetBox?.put(budget.id, budget);
  }

  Future<void> updateBudget(BudgetHiveModel budget) async {
    await _budgetBox?.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetBox?.delete(id);
  }

  Future<List<BudgetHiveModel>> getAllBudgets() async {
    return _budgetBox?.values.toList() ?? [];
  }

  Future<BudgetHiveModel?> getBudget(String id) async {
    return _budgetBox?.get(id);
  }

  Future<BudgetHiveModel?> getBudgetForCategoryAndMonth(
    String category,
    int month,
    int year,
  ) async {
    final budgets = await getAllBudgets();
    try {
      return budgets.firstWhere(
        (b) => b.category == category && b.month == month && b.year == year,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<BudgetHiveModel>> getBudgetsByMonth(int month, int year) async {
    final budgets = await getAllBudgets();
    return budgets.where((b) => b.month == month && b.year == year).toList();
  }

  Future<void> clearBudgets() async {
    await _budgetBox?.clear();
  }

  // Settings operations
  Future<void> setThemeMode(bool isDarkMode) async {
    await _settingsBox?.put('isDarkMode', isDarkMode);
  }

  Future<bool> getThemeMode() async {
    return _settingsBox?.get('isDarkMode', defaultValue: false) ?? false;
  }

  Future<void> clearAllData() async {
    await clearTransactions();
    await clearBudgets();
  }
}