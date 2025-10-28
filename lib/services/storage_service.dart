import 'package:hive/hive.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

class StorageService {
  static const String _transactionBoxName = 'transactions';
  static const String _budgetBoxName = 'budgets';
  static const String _settingsBoxName = 'settings';

  // Transaction Box
  Box<TransactionModel>? _transactionBox;
  Box<BudgetModel>? _budgetBox;
  Box? _settingsBox;

  Future<void> init() async {
    _transactionBox = await Hive.openBox<TransactionModel>(_transactionBoxName);
    _budgetBox = await Hive.openBox<BudgetModel>(_budgetBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // Transaction CRUD Operations
  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox?.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionBox?.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox?.delete(id);
  }

  List<TransactionModel> getAllTransactions() {
    return _transactionBox?.values.toList() ?? [];
  }

  TransactionModel? getTransaction(String id) {
    return _transactionBox?.get(id);
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    final transactions = getAllTransactions();
    return transactions
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  List<TransactionModel> getTransactionsByMonth(int month, int year) {
    final transactions = getAllTransactions();
    return transactions
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }

  // Budget CRUD Operations
  Future<void> addBudget(BudgetModel budget) async {
    await _budgetBox?.put(budget.id, budget);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _budgetBox?.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetBox?.delete(id);
  }

  List<BudgetModel> getAllBudgets() {
    return _budgetBox?.values.toList() ?? [];
  }

  BudgetModel? getBudget(String id) {
    return _budgetBox?.get(id);
  }

  BudgetModel? getBudgetForCategoryAndMonth(
    String category,
    int month,
    int year,
  ) {
    final budgets = getAllBudgets();
    try {
      return budgets.firstWhere(
        (b) => b.category == category && b.month == month && b.year == year,
      );
    } catch (e) {
      return null;
    }
  }

  List<BudgetModel> getBudgetsByMonth(int month, int year) {
    final budgets = getAllBudgets();
    return budgets.where((b) => b.month == month && b.year == year).toList();
  }

  // Settings
  Future<void> setThemeMode(bool isDarkMode) async {
    await _settingsBox?.put('isDarkMode', isDarkMode);
  }

  bool getThemeMode() {
    return _settingsBox?.get('isDarkMode', defaultValue: false) ?? false;
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _transactionBox?.clear();
    await _budgetBox?.clear();
  }
}
