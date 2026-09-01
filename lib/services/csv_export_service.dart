import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fintrack/domain/entities/transaction.dart';

class CsvExportService {
  static Future<void> exportTransactionsToCsv(
    List<Transaction> transactions,
  ) async {
    final List<List<dynamic>> rows = [
      ['ID', 'Title', 'Amount', 'Date', 'Category', 'Type', 'Description'],
    ];

    for (var transaction in transactions) {
      rows.add([
        transaction.id,
        transaction.title,
        transaction.amountInMajorUnits,
        transaction.date.toIso8601String(),
        transaction.category,
        transaction.type == TransactionType.income ? 'Income' : 'Expense',
        transaction.description ?? '',
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Get temporary directory and save file
    final tempDir = await getTemporaryDirectory();
    final fileName = 'fintrack_transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(csv);

    // Share the file using system share sheet (new API)
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'FinTrack Transaction Export',
        subject: 'Transaction Export',
      ),
    );
  }
}