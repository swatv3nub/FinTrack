import 'package:flutter/material.dart';
import 'package:fintrack/domain/entities/budget.dart';
import 'package:fintrack/domain/usecases/budget_usecases.dart';
import 'package:fintrack/domain/usecases/transaction_usecases.dart';

class BudgetProvider extends ChangeNotifier {
  final GetAllBudgetsUseCase _getAllBudgetsUseCase;
  final GetBudgetsByMonthUseCase _getBudgetsByMonthUseCase;
  final GetBudgetForCategoryUseCase _getBudgetForCategoryUseCase;
  final AddBudgetUseCase _addBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final CheckBudgetStatusUseCase _checkBudgetStatusUseCase;
  final GetBudgetProgressUseCase _getBudgetProgressUseCase;

  List<Budget> _budgets = [];

  BudgetProvider({
    required GetAllBudgetsUseCase getAllBudgetsUseCase,
    required GetBudgetsByMonthUseCase getBudgetsByMonthUseCase,
    required GetBudgetForCategoryUseCase getBudgetForCategoryUseCase,
    required AddBudgetUseCase addBudgetUseCase,
    required UpdateBudgetUseCase updateBudgetUseCase,
    required DeleteBudgetUseCase deleteBudgetUseCase,
    required CheckBudgetStatusUseCase checkBudgetStatusUseCase,
    required GetBudgetProgressUseCase getBudgetProgressUseCase,
  })  : _getAllBudgetsUseCase = getAllBudgetsUseCase,
        _getBudgetsByMonthUseCase = getBudgetsByMonthUseCase,
        _getBudgetForCategoryUseCase = getBudgetForCategoryUseCase,
        _addBudgetUseCase = addBudgetUseCase,
        _updateBudgetUseCase = updateBudgetUseCase,
        _deleteBudgetUseCase = deleteBudgetUseCase,
        _checkBudgetStatusUseCase = checkBudgetStatusUseCase,
        _getBudgetProgressUseCase = getBudgetProgressUseCase {
    loadBudgets();
  }

  List<Budget> get budgets => _budgets;

  Future<void> loadBudgets() async {
    _budgets = await _getAllBudgetsUseCase();
    notifyListeners();
  }

  Future<List<Budget>> getBudgetsByMonth(int month, int year) async {
    return _getBudgetsByMonthUseCase(month, year);
  }

  Future<Budget?> getBudgetForCategory(String category, int month, int year) async {
    return _getBudgetForCategoryUseCase(category, month, year);
  }

  Future<int> getBudgetAmount(String category, int month, int year) async {
    final budget = await _getBudgetForCategoryUseCase(category, month, year);
    return budget?.amount ?? 0;
  }

  Future<void> addBudget(Budget budget) async {
    await _addBudgetUseCase(budget);
    await loadBudgets();
  }

  Future<void> updateBudget(Budget budget) async {
    await _updateBudgetUseCase(budget);
    await loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await _deleteBudgetUseCase(id);
    await loadBudgets();
  }

  Future<BudgetStatus> getBudgetStatus(
    String category,
    int month,
    int year,
  ) async {
    return _checkBudgetStatusUseCase(category, month, year);
  }

  Future<double> getBudgetProgress(
    String category,
    int month,
    int year,
  ) async {
    return _getBudgetProgressUseCase(category, month, year);
  }

  // Synchronous versions for UI (uses cached data)
  BudgetStatus getBudgetStatusSync(String category, int month, int year) {
    final budget = _budgets.firstWhere(
      (b) => b.category == category && b.month == month && b.year == year,
      orElse: () => Budget(
        id: '',
        category: category,
        amount: 0,
        month: month,
        year: year,
      ),
    );

    if (budget.amount == 0) return BudgetStatus.underBudget;

    // Note: This is a simplified sync version. For accurate results,
    // use the async version which queries transactions.
    return BudgetStatus.underBudget;
  }
}