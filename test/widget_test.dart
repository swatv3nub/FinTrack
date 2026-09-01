import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/presentation/providers/transaction_provider.dart';
import 'package:fintrack/presentation/providers/budget_provider.dart';
import 'package:fintrack/presentation/providers/theme_provider.dart';
import 'package:fintrack/domain/entities/transaction.dart';
import 'package:fintrack/domain/entities/budget.dart';
import 'package:fintrack/domain/usecases/transaction_usecases.dart';
import 'package:fintrack/domain/usecases/budget_usecases.dart';
import 'package:fintrack/domain/usecases/settings_usecases.dart';
import 'package:fintrack/domain/repositories/transaction_repository.dart';
import 'package:fintrack/domain/repositories/budget_repository.dart';
import 'package:fintrack/domain/repositories/settings_repository.dart';
import 'package:fintrack/presentation/widgets/balance_card.dart';
import 'package:fintrack/presentation/widgets/transaction_list_item.dart';
import 'package:fintrack/core/constants/theme.dart';

// Mock Repositories
class MockTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [];

  @override
  Future<List<Transaction>> getAllTransactions() async => _transactions;

  @override
  Future<Transaction?> getTransaction(String id) async =>
      _transactions.where((t) => t.id == id).firstOrNull;

  @override
  Future<List<Transaction>> getTransactionsByMonth(int month, int year) async =>
      _transactions.where((t) => t.date.month == month && t.date.year == year).toList();

  @override
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async =>
      _transactions.where((t) => t.date.isAfter(start) && t.date.isBefore(end)).toList();

  @override
  Future<void> addTransaction(Transaction transaction) async => _transactions.add(transaction);

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) _transactions[index] = transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async => _transactions.removeWhere((t) => t.id == id);

  @override
  Future<void> deleteAllTransactions() async => _transactions.clear();
}

class MockBudgetRepository implements BudgetRepository {
  final List<Budget> _budgets = [];

  @override
  Future<List<Budget>> getAllBudgets() async => _budgets;

  @override
  Future<Budget?> getBudget(String id) async => _budgets.where((b) => b.id == id).firstOrNull;

  @override
  Future<Budget?> getBudgetForCategoryAndMonth(String category, int month, int year) async {
    try {
      return _budgets.firstWhere((b) => b.category == category && b.month == month && b.year == year);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Budget>> getBudgetsByMonth(int month, int year) async =>
      _budgets.where((b) => b.month == month && b.year == year).toList();

  @override
  Future<void> addBudget(Budget budget) async => _budgets.add(budget);

  @override
  Future<void> updateBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) _budgets[index] = budget;
  }

  @override
  Future<void> deleteBudget(String id) async => _budgets.removeWhere((b) => b.id == id);

  @override
  Future<void> deleteAllBudgets() async => _budgets.clear();
}

class MockSettingsRepository implements SettingsRepository {
  bool _isDarkMode = false;

  @override
  Future<bool> getThemeMode() async => _isDarkMode;

  @override
  Future<void> setThemeMode(bool isDarkMode) async => _isDarkMode = isDarkMode;

  @override
  Future<String?> getCurrencyCode() async => 'INR';

  @override
  Future<void> setCurrencyCode(String code) async {}
}

void main() {
  group('Widget Tests', () {
    testWidgets('BalanceCard displays correct balance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BalanceCard(
              balance: 100000, // 1000.00
              income: 200000, // 2000.00
              expense: 100000, // 1000.00
            ),
          ),
        ),
      );

      expect(find.text('Current Balance'), findsOneWidget);
      expect(find.text('₹1000.00'), findsNWidgets(2)); // balance + income
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('BalanceCard shows negative balance in red', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BalanceCard(
              balance: -50000,
              income: 100000,
              expense: 150000,
            ),
          ),
        ),
      );

      expect(find.text('-₹500.00'), findsOneWidget);
    });

    testWidgets('TransactionListItem displays transaction data', (tester) async {
      final transaction = Transaction(
        id: '1',
        title: 'Groceries',
        amount: 5000, // 50.00
        date: DateTime(2024, 10, 28),
        category: 'Food',
        type: TransactionType.expense,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TransactionListItem(
              transaction: transaction,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('-₹50.00'), findsOneWidget);
    });

    testWidgets('Income transaction shows positive sign', (tester) async {
      final transaction = Transaction(
        id: '1',
        title: 'Salary',
        amount: 500000,
        date: DateTime(2024, 10, 28),
        category: 'Salary',
        type: TransactionType.income,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TransactionListItem(
              transaction: transaction,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Salary'), findsNWidgets(2));
      expect(find.text('+₹5000.00'), findsOneWidget);
    });
  });

  group('TransactionProvider Tests', () {
    late MockTransactionRepository mockRepository;
    late TransactionProvider provider;

    setUp(() {
      mockRepository = MockTransactionRepository();
      provider = TransactionProvider(
        getAllTransactionsUseCase: GetAllTransactionsUseCase(mockRepository),
        getRecentTransactionsUseCase: GetRecentTransactionsUseCase(mockRepository),
        getTransactionsByMonthUseCase: GetTransactionsByMonthUseCase(mockRepository),
        getExpenseForCategoryUseCase: GetExpenseForCategoryUseCase(mockRepository),
        addTransactionUseCase: AddTransactionUseCase(mockRepository),
        updateTransactionUseCase: UpdateTransactionUseCase(mockRepository),
        deleteTransactionUseCase: DeleteTransactionUseCase(mockRepository),
      );
    });

    test('Initial state is empty', () {
      expect(provider.transactions, isEmpty);
      expect(provider.totalIncome, 0);
      expect(provider.totalExpense, 0);
      expect(provider.currentBalance, 0);
    });

    test('Add transaction updates totals', () async {
      final transaction = Transaction(
        id: '1',
        title: 'Test',
        amount: 10000,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction);

      expect(provider.transactions.length, 1);
      expect(provider.totalExpense, 10000);
      expect(provider.currentBalance, -10000);
    });

    test('Calculate current balance correctly', () async {
      final income = Transaction(
        id: '1',
        title: 'Salary',
        amount: 500000,
        date: DateTime.now(),
        category: 'Salary',
        type: TransactionType.income,
      );

      final expense = Transaction(
        id: '2',
        title: 'Groceries',
        amount: 50000,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(income);
      await provider.addTransaction(expense);

      expect(provider.totalIncome, 500000);
      expect(provider.totalExpense, 50000);
      expect(provider.currentBalance, 450000);
    });

    test('Delete transaction updates totals', () async {
      final transaction = Transaction(
        id: '1',
        title: 'Test',
        amount: 10000,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction);
      expect(provider.transactions.length, 1);

      await provider.deleteTransaction('1');
      expect(provider.transactions.length, 0);
      expect(provider.totalExpense, 0);
    });

    test('Undo delete restores transaction', () async {
      final transaction = Transaction(
        id: '1',
        title: 'Test',
        amount: 10000,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction);
      await provider.deleteTransaction('1');
      expect(provider.transactions.length, 0);

      await provider.undoDelete();
      expect(provider.transactions.length, 1);
    });

    test('Expenses by category calculated correctly', () async {
      final transaction1 = Transaction(
        id: '1',
        title: 'Groceries',
        amount: 10000,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      final transaction2 = Transaction(
        id: '2',
        title: 'Restaurant',
        amount: 5000,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      final transaction3 = Transaction(
        id: '3',
        title: 'Gas',
        amount: 4000,
        date: DateTime.now(),
        category: 'Travel',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction1);
      await provider.addTransaction(transaction2);
      await provider.addTransaction(transaction3);

      final expensesByCategory = provider.expensesByCategory;

      expect(expensesByCategory['Food'], 15000);
      expect(expensesByCategory['Travel'], 4000);
    });
  });
}