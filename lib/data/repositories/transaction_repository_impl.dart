import 'package:fintrack/data/datasources/hive_data_source.dart';
import 'package:fintrack/data/models/transaction_hive_model.dart';
import 'package:fintrack/domain/entities/transaction.dart';
import 'package:fintrack/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final HiveDataSource _dataSource;

  TransactionRepositoryImpl(this._dataSource);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final hiveModels = await _dataSource.getAllTransactions();
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Transaction?> getTransaction(String id) async {
    final hiveModel = await _dataSource.getTransaction(id);
    return hiveModel?.toEntity();
  }

  @override
  Future<List<Transaction>> getTransactionsByMonth(int month, int year) async {
    final hiveModels = await _dataSource.getTransactionsByMonth(month, year);
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final hiveModels = await _dataSource.getTransactionsByDateRange(start, end);
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final hiveModel = TransactionHiveModel.fromEntity(transaction);
    await _dataSource.addTransaction(hiveModel);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final hiveModel = TransactionHiveModel.fromEntity(transaction);
    await _dataSource.updateTransaction(hiveModel);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _dataSource.deleteTransaction(id);
  }

  @override
  Future<void> deleteAllTransactions() async {
    await _dataSource.clearTransactions();
  }
}