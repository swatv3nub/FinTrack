import 'package:fintrack/domain/entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getAllBudgets();
  Future<Budget?> getBudget(String id);
  Future<Budget?> getBudgetForCategoryAndMonth(String category, int month, int year);
  Future<List<Budget>> getBudgetsByMonth(int month, int year);
  Future<void> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);
  Future<void> deleteAllBudgets();
}