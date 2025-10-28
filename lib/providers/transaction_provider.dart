import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';

class TransactionProvider with ChangeNotifier {
  final StorageService _storageService;
  List<TransactionModel> _transactions = [];
  TransactionModel? _lastDeletedTransaction;

  TransactionProvider(this._storageService) {
    loadTransactions();
  }

  List<TransactionModel> get transactions => _transactions;

  List<TransactionModel> get recentTransactions {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get currentBalance => totalIncome - totalExpense;

  Map<String, double> get expensesByCategory {
    final expenses =
        _transactions.where((t) => t.type == TransactionType.expense);
    final categoryMap = <String, double>{};

    for (var expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;
    }

    return categoryMap;
  }

  List<TransactionModel> getTransactionsByMonth(int month, int year) {
    return _storageService.getTransactionsByMonth(month, year);
  }

  double getExpenseForCategory(String category, int month, int year) {
    final transactions = getTransactionsByMonth(month, year);
    return transactions
        .where(
          (t) => t.type == TransactionType.expense && t.category == category,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Future<void> loadTransactions() async {
    _transactions = _storageService.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _storageService.addTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _storageService.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    _lastDeletedTransaction = _transactions.firstWhere((t) => t.id == id);
    await _storageService.deleteTransaction(id);
    await loadTransactions();
  }

  Future<void> undoDelete() async {
    if (_lastDeletedTransaction != null) {
      await _storageService.addTransaction(_lastDeletedTransaction!);
      _lastDeletedTransaction = null;
      await loadTransactions();
    }
  }
}
