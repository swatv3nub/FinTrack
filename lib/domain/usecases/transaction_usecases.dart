import 'package:fintrack/domain/entities/transaction.dart';
import 'package:fintrack/domain/repositories/transaction_repository.dart';

class GetAllTransactionsUseCase {
  final TransactionRepository repository;

  GetAllTransactionsUseCase(this.repository);

  Future<List<Transaction>> call() async {
    return repository.getAllTransactions();
  }
}

class GetTransactionsByMonthUseCase {
  final TransactionRepository repository;

  GetTransactionsByMonthUseCase(this.repository);

  Future<List<Transaction>> call(int month, int year) async {
    return repository.getTransactionsByMonth(month, year);
  }
}

class GetTransactionsByDateRangeUseCase {
  final TransactionRepository repository;

  GetTransactionsByDateRangeUseCase(this.repository);

  Future<List<Transaction>> call(DateTime start, DateTime end) async {
    return repository.getTransactionsByDateRange(start, end);
  }
}

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call(Transaction transaction) async {
    return repository.addTransaction(transaction);
  }
}

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> call(Transaction transaction) async {
    return repository.updateTransaction(transaction);
  }
}

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteTransaction(id);
  }
}

class GetExpensesByCategoryUseCase {
  final TransactionRepository repository;

  GetExpensesByCategoryUseCase(this.repository);

  Future<Map<String, int>> call() async {
    final transactions = await repository.getAllTransactions();
    final expenses = transactions.where((t) => t.type == TransactionType.expense);
    final categoryMap = <String, int>{};

    for (var expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;
    }

    return categoryMap;
  }
}

class GetExpenseForCategoryUseCase {
  final TransactionRepository repository;

  GetExpenseForCategoryUseCase(this.repository);

  Future<int> call(String category, int month, int year) async {
    final transactions = await repository.getTransactionsByMonth(month, year);
    int sum = 0;
    for (var t in transactions) {
      if (t.type == TransactionType.expense && t.category == category) {
        sum += t.amount;
      }
    }
    return sum;
  }
}

class GetRecentTransactionsUseCase {
  final TransactionRepository repository;
  final int limit;

  GetRecentTransactionsUseCase(this.repository, {this.limit = 10});

  Future<List<Transaction>> call() async {
    final transactions = await repository.getAllTransactions();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(limit).toList();
  }
}