import 'package:flutter/material.dart';
import 'package:fintrack/domain/entities/transaction.dart';
import 'package:fintrack/domain/usecases/transaction_usecases.dart';

class TransactionProvider extends ChangeNotifier {
  final GetAllTransactionsUseCase _getAllTransactionsUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final GetTransactionsByMonthUseCase _getTransactionsByMonthUseCase;
  final GetExpenseForCategoryUseCase _getExpenseForCategoryUseCase;
  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  List<Transaction> _transactions = [];
  Transaction? _lastDeletedTransaction;

  TransactionProvider({
    required GetAllTransactionsUseCase getAllTransactionsUseCase,
    required GetRecentTransactionsUseCase getRecentTransactionsUseCase,
    required GetTransactionsByMonthUseCase getTransactionsByMonthUseCase,
    required GetExpenseForCategoryUseCase getExpenseForCategoryUseCase,
    required AddTransactionUseCase addTransactionUseCase,
    required UpdateTransactionUseCase updateTransactionUseCase,
    required DeleteTransactionUseCase deleteTransactionUseCase,
  })  : _getAllTransactionsUseCase = getAllTransactionsUseCase,
        _getRecentTransactionsUseCase = getRecentTransactionsUseCase,
        _getTransactionsByMonthUseCase = getTransactionsByMonthUseCase,
        _getExpenseForCategoryUseCase = getExpenseForCategoryUseCase,
        _addTransactionUseCase = addTransactionUseCase,
        _updateTransactionUseCase = updateTransactionUseCase,
        _deleteTransactionUseCase = deleteTransactionUseCase {
    loadTransactions();
  }

  List<Transaction> get transactions => _transactions;

  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }

  int get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int get currentBalance => totalIncome - totalExpense;

  Map<String, int> get expensesByCategory {
    final expenses = _transactions.where((t) => t.type == TransactionType.expense);
    final categoryMap = <String, int>{};

    for (var expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;
    }

    return categoryMap;
  }

  Future<void> loadTransactions() async {
    _transactions = await _getAllTransactionsUseCase();
    notifyListeners();
  }

  Future<List<Transaction>> getTransactionsByMonth(int month, int year) async {
    return _getTransactionsByMonthUseCase(month, year);
  }

  Future<int> getExpenseForCategory(String category, int month, int year) async {
    return _getExpenseForCategoryUseCase(category, month, year);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _addTransactionUseCase(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _updateTransactionUseCase(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    _lastDeletedTransaction = _transactions.firstWhere((t) => t.id == id);
    await _deleteTransactionUseCase(id);
    await loadTransactions();
  }

  Future<void> undoDelete() async {
    if (_lastDeletedTransaction != null) {
      await _addTransactionUseCase(_lastDeletedTransaction!);
      _lastDeletedTransaction = null;
      await loadTransactions();
    }
  }
}