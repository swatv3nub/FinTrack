import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/domain/entities/transaction.dart';

void main() {
  group('Transaction Entity Tests', () {
    test('Transaction creation', () {
      final transaction = Transaction(
        id: '1',
        title: 'Test Transaction',
        amount: 10000, // 100.00 in minor units
        date: DateTime(2024, 1, 1),
        category: 'Food',
        type: TransactionType.expense,
        description: 'Test description',
      );

      expect(transaction.id, '1');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 10000);
      expect(transaction.amountInMajorUnits, 100.0);
      expect(transaction.formattedAmount, '₹100.00');
      expect(transaction.category, 'Food');
      expect(transaction.type, TransactionType.expense);
      expect(transaction.description, 'Test description');
      expect(transaction.signedAmount, '-₹100.00');
    });

    test('Transaction copyWith', () {
      final transaction = Transaction(
        id: '1',
        title: 'Test',
        amount: 10000,
        date: DateTime(2024, 1, 1),
        category: 'Food',
        type: TransactionType.expense,
      );

      final updated = transaction.copyWith(
        title: 'Updated Test',
        amount: 20000,
      );

      expect(updated.id, '1');
      expect(updated.title, 'Updated Test');
      expect(updated.amount, 20000);
      expect(updated.amountInMajorUnits, 200.0);
      expect(updated.category, 'Food');
    });

    test('Income transaction signed amount', () {
      final transaction = Transaction(
        id: '1',
        title: 'Salary',
        amount: 500000, // 5000.00
        date: DateTime(2024, 1, 1),
        category: 'Salary',
        type: TransactionType.income,
      );

      expect(transaction.signedAmount, '+₹5000.00');
      expect(transaction.type == TransactionType.income, true);
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

    test('Categories for type returns correct list', () {
      final expenseCats = TransactionCategories.categoriesForType(TransactionType.expense);
      final incomeCats = TransactionCategories.categoriesForType(TransactionType.income);

      expect(expenseCats, equals(TransactionCategories.expenseCategories));
      expect(incomeCats, equals(TransactionCategories.incomeCategories));
    });
  });
}