import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/models/budget_model.dart';

void main() {
  group('BudgetModel Tests', () {
    test('BudgetModel creation', () {
      final budget = BudgetModel(
        id: '1',
        category: 'Food',
        amount: 500.0,
        month: 10,
        year: 2024,
      );

      expect(budget.id, '1');
      expect(budget.category, 'Food');
      expect(budget.amount, 500.0);
      expect(budget.month, 10);
      expect(budget.year, 2024);
    });

    test('BudgetModel copyWith', () {
      final budget = BudgetModel(
        id: '1',
        category: 'Food',
        amount: 500.0,
        month: 10,
        year: 2024,
      );

      final updated = budget.copyWith(
        amount: 600.0,
        month: 11,
      );

      expect(updated.id, '1');
      expect(updated.category, 'Food');
      expect(updated.amount, 600.0);
      expect(updated.month, 11);
      expect(updated.year, 2024);
    });

    test('BudgetModel toMap', () {
      final budget = BudgetModel(
        id: '1',
        category: 'Food',
        amount: 500.0,
        month: 10,
        year: 2024,
      );

      final map = budget.toMap();

      expect(map['id'], '1');
      expect(map['category'], 'Food');
      expect(map['amount'], 500.0);
      expect(map['month'], 10);
      expect(map['year'], 2024);
    });
  });
}
