import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
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

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/fintrack_transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);

    await file.writeAsString(csv);
    return file;
  }
}
