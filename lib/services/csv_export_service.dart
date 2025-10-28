import 'dart:io';
import 'package:csv/csv.dart';
import '../models/transaction_model.dart';

class CsvExportService {
  static Future<File> exportTransactionsToCsv(
    List<TransactionModel> transactions,
  ) async {
    final List<List<dynamic>> rows = [
      ['ID', 'Title', 'Amount', 'Date', 'Category', 'Type', 'Description'],
    ];

    for (var transaction in transactions) {
      rows.add([
        transaction.id,
        transaction.title,
        transaction.amount,
        transaction.date.toIso8601String(),
        transaction.category,
        transaction.type == TransactionType.income ? 'Income' : 'Expense',
        transaction.description ?? '',
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Save directly to Downloads folder
    const downloadsPath = '/storage/emulated/0/Download';
    final path =
        '$downloadsPath/fintrack_transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);

    // Create directory if it doesn't exist
    await file.parent.create(recursive: true);
    
    await file.writeAsString(csv);
    return file;
  }
}
