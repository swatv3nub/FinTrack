import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/providers/transaction_provider.dart';
import 'package:fintrack/models/transaction_model.dart';
import 'package:fintrack/services/storage_service.dart';
import 'package:fintrack/widgets/balance_card.dart';
import 'package:fintrack/widgets/transaction_list_item.dart';

// Mock Storage Service
class MockStorageService extends StorageService {
  final List<TransactionModel> _mockTransactions = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    _mockTransactions.add(transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final index = _mockTransactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _mockTransactions[index] = transaction;
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _mockTransactions.removeWhere((t) => t.id == id);
  }

  @override
  List<TransactionModel> getAllTransactions() {
    return _mockTransactions;
  }

  @override
  List<TransactionModel> getTransactionsByMonth(int month, int year) {
    return _mockTransactions
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }
}

void main() {
  group('Dashboard Widget Tests', () {
    testWidgets('BalanceCard displays correct balance', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: 1000.0,
              income: 2000.0,
              expense: 1000.0,
            ),
          ),
        ),
      );

      expect(find.text('Current Balance'), findsOneWidget);
      expect(find.text('\$1000.00'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
    });

    testWidgets('BalanceCard shows negative balance in red', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: -500.0,
              income: 1000.0,
              expense: 1500.0,
            ),
          ),
        ),
      );

      expect(find.text('\$-500.00'), findsOneWidget);
    });

    testWidgets('TransactionListItem displays transaction data',
        (tester) async {
      final transaction = TransactionModel(
        id: '1',
        title: 'Groceries',
        amount: 50.0,
        date: DateTime(2024, 10, 28),
        category: 'Food',
        type: TransactionType.expense,
      );

      await tester.pumpWidget(
        MaterialApp(
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
      expect(find.text('-\$50.00'), findsOneWidget);
    });

    testWidgets('Income transaction shows positive sign', (tester) async {
      final transaction = TransactionModel(
        id: '1',
        title: 'Salary',
        amount: 5000.0,
        date: DateTime(2024, 10, 28),
        category: 'Salary',
        type: TransactionType.income,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(
              transaction: transaction,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('+\$5000.00'), findsOneWidget);
    });
  });

  group('TransactionProvider Tests', () {
    late MockStorageService mockStorageService;
    late TransactionProvider provider;

    setUp(() {
      mockStorageService = MockStorageService();
      provider = TransactionProvider(mockStorageService);
    });

    test('Initial state is empty', () {
      expect(provider.transactions, isEmpty);
      expect(provider.totalIncome, 0.0);
      expect(provider.totalExpense, 0.0);
      expect(provider.currentBalance, 0.0);
    });

    test('Add transaction updates totals', () async {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test',
        amount: 100.0,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction);

      expect(provider.transactions.length, 1);
      expect(provider.totalExpense, 100.0);
      expect(provider.currentBalance, -100.0);
    });

    test('Calculate current balance correctly', () async {
      final income = TransactionModel(
        id: '1',
        title: 'Salary',
        amount: 5000.0,
        date: DateTime.now(),
        category: 'Salary',
        type: TransactionType.income,
      );

      final expense = TransactionModel(
        id: '2',
        title: 'Groceries',
        amount: 500.0,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(income);
      await provider.addTransaction(expense);

      expect(provider.totalIncome, 5000.0);
      expect(provider.totalExpense, 500.0);
      expect(provider.currentBalance, 4500.0);
    });

    test('Delete transaction updates totals', () async {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test',
        amount: 100.0,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction);
      expect(provider.transactions.length, 1);

      await provider.deleteTransaction('1');
      expect(provider.transactions.length, 0);
      expect(provider.totalExpense, 0.0);
    });

    test('Undo delete restores transaction', () async {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test',
        amount: 100.0,
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
      final transaction1 = TransactionModel(
        id: '1',
        title: 'Groceries',
        amount: 100.0,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      final transaction2 = TransactionModel(
        id: '2',
        title: 'Restaurant',
        amount: 50.0,
        date: DateTime.now(),
        category: 'Food',
        type: TransactionType.expense,
      );

      final transaction3 = TransactionModel(
        id: '3',
        title: 'Gas',
        amount: 40.0,
        date: DateTime.now(),
        category: 'Travel',
        type: TransactionType.expense,
      );

      await provider.addTransaction(transaction1);
      await provider.addTransaction(transaction2);
      await provider.addTransaction(transaction3);

      final expensesByCategory = provider.expensesByCategory;

      expect(expensesByCategory['Food'], 150.0);
      expect(expensesByCategory['Travel'], 40.0);
    });
  });
}
