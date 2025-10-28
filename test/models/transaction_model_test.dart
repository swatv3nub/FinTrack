import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/models/transaction_model.dart';

void main() {
  group('TransactionModel Tests', () {
    test('TransactionModel creation', () {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test Transaction',
        amount: 100.0,
        date: DateTime(2024, 1, 1),
        category: 'Food',
        type: TransactionType.expense,
        description: 'Test description',
      );

      expect(transaction.id, '1');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 100.0);
      expect(transaction.category, 'Food');
      expect(transaction.type, TransactionType.expense);
      expect(transaction.description, 'Test description');
    });

    test('TransactionModel copyWith', () {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test',
        amount: 100.0,
        date: DateTime(2024, 1, 1),
        category: 'Food',
        type: TransactionType.expense,
      );

      final updated = transaction.copyWith(
        title: 'Updated Test',
        amount: 200.0,
      );

      expect(updated.id, '1');
      expect(updated.title, 'Updated Test');
      expect(updated.amount, 200.0);
      expect(updated.category, 'Food');
    });

    test('TransactionModel toMap', () {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test',
        amount: 100.0,
        date: DateTime(2024, 1, 1),
        category: 'Food',
        type: TransactionType.expense,
      );

      final map = transaction.toMap();

      expect(map['id'], '1');
      expect(map['title'], 'Test');
      expect(map['amount'], 100.0);
      expect(map['category'], 'Food');
    });
  });

  group('TransactionCategories Tests', () {
    test('Expense categories are defined', () {
      expect(TransactionCategories.expenseCategories.isNotEmpty, true);
      expect(
        TransactionCategories.expenseCategories.contains('Food'),
        true,
      );
    });

    test('Income categories are defined', () {
      expect(TransactionCategories.incomeCategories.isNotEmpty, true);
      expect(
        TransactionCategories.incomeCategories.contains('Salary'),
        true,
      );
    });
  });
}
