import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../services/storage_service.dart';

class BudgetProvider with ChangeNotifier {
  final StorageService _storageService;
  List<BudgetModel> _budgets = [];

  BudgetProvider(this._storageService) {
    loadBudgets();
  }

  List<BudgetModel> get budgets => _budgets;

  List<BudgetModel> getBudgetsByMonth(int month, int year) {
    return _storageService.getBudgetsByMonth(month, year);
  }

  BudgetModel? getBudgetForCategory(String category, int month, int year) {
    return _storageService.getBudgetForCategoryAndMonth(category, month, year);
  }

  double getBudgetAmount(String category, int month, int year) {
    final budget = getBudgetForCategory(category, month, year);
    return budget?.amount ?? 0.0;
  }

  Future<void> loadBudgets() async {
    _budgets = _storageService.getAllBudgets();
    notifyListeners();
  }

  Future<void> addBudget(BudgetModel budget) async {
    await _storageService.addBudget(budget);
    await loadBudgets();
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _storageService.updateBudget(budget);
    await loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await _storageService.deleteBudget(id);
    await loadBudgets();
  }

  // Check if budget is exceeded
  bool isBudgetExceeded(
    String category,
    double spent,
    int month,
    int year,
  ) {
    final budgetAmount = getBudgetAmount(category, month, year);
    return budgetAmount > 0 && spent > budgetAmount;
  }

  // Check if approaching budget limit (>80%)
  bool isApproachingLimit(
    String category,
    double spent,
    int month,
    int year,
  ) {
    final budgetAmount = getBudgetAmount(category, month, year);
    return budgetAmount > 0 && spent > (budgetAmount * 0.8);
  }

  // Get budget status color
  Color getBudgetStatusColor(String category, double spent, int month, int year) {
    if (isBudgetExceeded(category, spent, month, year)) {
      return Colors.red;
    } else if (isApproachingLimit(category, spent, month, year)) {
      return Colors.orange;
    }
    return Colors.green;
  }
}
