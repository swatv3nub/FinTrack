import 'package:fintrack/data/datasources/hive_data_source.dart';
import 'package:fintrack/data/models/budget_hive_model.dart';
import 'package:fintrack/domain/entities/budget.dart';
import 'package:fintrack/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final HiveDataSource _dataSource;

  BudgetRepositoryImpl(this._dataSource);

  @override
  Future<List<Budget>> getAllBudgets() async {
    final hiveModels = await _dataSource.getAllBudgets();
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Budget?> getBudget(String id) async {
    final hiveModel = await _dataSource.getBudget(id);
    return hiveModel?.toEntity();
  }

  @override
  Future<Budget?> getBudgetForCategoryAndMonth(
    String category,
    int month,
    int year,
  ) async {
    final hiveModel = await _dataSource.getBudgetForCategoryAndMonth(category, month, year);
    return hiveModel?.toEntity();
  }

  @override
  Future<List<Budget>> getBudgetsByMonth(int month, int year) async {
    final hiveModels = await _dataSource.getBudgetsByMonth(month, year);
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addBudget(Budget budget) async {
    final hiveModel = BudgetHiveModel.fromEntity(budget);
    await _dataSource.addBudget(hiveModel);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    final hiveModel = BudgetHiveModel.fromEntity(budget);
    await _dataSource.updateBudget(hiveModel);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _dataSource.deleteBudget(id);
  }

  @override
  Future<void> deleteAllBudgets() async {
    await _dataSource.clearBudgets();
  }
}