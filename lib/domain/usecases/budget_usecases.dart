import 'package:fintrack/domain/entities/budget.dart';
import 'package:fintrack/domain/entities/transaction.dart';
import 'package:fintrack/domain/repositories/budget_repository.dart';
import 'package:fintrack/domain/repositories/transaction_repository.dart';

class GetAllBudgetsUseCase {
  final BudgetRepository repository;

  GetAllBudgetsUseCase(this.repository);

  Future<List<Budget>> call() async {
    return repository.getAllBudgets();
  }
}

class GetBudgetsByMonthUseCase {
  final BudgetRepository repository;

  GetBudgetsByMonthUseCase(this.repository);

  Future<List<Budget>> call(int month, int year) async {
    return repository.getBudgetsByMonth(month, year);
  }
}

class GetBudgetForCategoryUseCase {
  final BudgetRepository repository;

  GetBudgetForCategoryUseCase(this.repository);

  Future<Budget?> call(String category, int month, int year) async {
    return repository.getBudgetForCategoryAndMonth(category, month, year);
  }
}

class AddBudgetUseCase {
  final BudgetRepository repository;

  AddBudgetUseCase(this.repository);

  Future<void> call(Budget budget) async {
    return repository.addBudget(budget);
  }
}

class UpdateBudgetUseCase {
  final BudgetRepository repository;

  UpdateBudgetUseCase(this.repository);

  Future<void> call(Budget budget) async {
    return repository.updateBudget(budget);
  }
}

class DeleteBudgetUseCase {
  final BudgetRepository repository;

  DeleteBudgetUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteBudget(id);
  }
}

class CheckBudgetStatusUseCase {
  final BudgetRepository budgetRepository;
  final TransactionRepository transactionRepository;

  CheckBudgetStatusUseCase(this.budgetRepository, this.transactionRepository);

  Future<BudgetStatus> call(String category, int month, int year) async {
    final budget = await budgetRepository.getBudgetForCategoryAndMonth(
      category,
      month,
      year,
    );
    if (budget == null || budget.amount == 0) {
      return BudgetStatus.underBudget;
    }

    final spent = await transactionRepository.getTransactionsByMonth(month, year);
    final categorySpent = spent
        .where(
          (t) => t.type == TransactionType.expense && t.category == category,
        )
        .fold(0, (sum, t) => sum + t.amount);

    final percentage = categorySpent / budget.amount;

    if (percentage > 1.0) {
      return BudgetStatus.overBudget;
    } else if (percentage > 0.8) {
      return BudgetStatus.approachingLimit;
    }
    return BudgetStatus.underBudget;
  }
}

class GetBudgetProgressUseCase {
  final BudgetRepository budgetRepository;
  final TransactionRepository transactionRepository;

  GetBudgetProgressUseCase(this.budgetRepository, this.transactionRepository);

  Future<double> call(String category, int month, int year) async {
    final budget = await budgetRepository.getBudgetForCategoryAndMonth(
      category,
      month,
      year,
    );
    if (budget == null || budget.amount == 0) {
      return 0.0;
    }

    final spent = await transactionRepository.getTransactionsByMonth(month, year);
    final categorySpent = spent
        .where(
          (t) => t.type == TransactionType.expense && t.category == category,
        )
        .fold(0, (sum, t) => sum + t.amount);

    return (categorySpent / budget.amount).clamp(0.0, 1.0);
  }
}