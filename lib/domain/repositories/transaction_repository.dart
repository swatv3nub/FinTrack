import 'package:fintrack/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAllTransactions();
  Future<Transaction?> getTransaction(String id);
  Future<List<Transaction>> getTransactionsByMonth(int month, int year);
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<void> deleteAllTransactions();
}