import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/domain/entities/budget.dart';

void main() {
  group('Budget Entity Tests', () {
    test('Budget creation', () {
      final budget = Budget(
        id: '1',
        category: 'Food',
        amount: 50000, // 500.00 in minor units
        month: 10,
        year: 2024,
      );

      expect(budget.id, '1');
      expect(budget.category, 'Food');
      expect(budget.amount, 50000);
      expect(budget.amountInMajorUnits, 500.0);
      expect(budget.formattedAmount, '₹500.00');
      expect(budget.month, 10);
      expect(budget.year, 2024);
      expect(budget.periodLabel, 'October 2024');
    });

    test('Budget copyWith', () {
      final budget = Budget(
        id: '1',
        category: 'Food',
        amount: 50000,
        month: 10,
        year: 2024,
      );

      final updated = budget.copyWith(
        amount: 60000,
        month: 11,
      );

      expect(updated.id, '1');
      expect(updated.category, 'Food');
      expect(updated.amount, 60000);
      expect(updated.amountInMajorUnits, 600.0);
      expect(updated.month, 11);
      expect(updated.year, 2024);
    });
  });

  group('BudgetStatus Tests', () {
    test('BudgetStatus labels', () {
      expect(BudgetStatus.underBudget.label, 'Under Budget');
      expect(BudgetStatus.approachingLimit.label, 'Approaching Limit');
      expect(BudgetStatus.overBudget.label, 'Over Budget');
    });
  });
}