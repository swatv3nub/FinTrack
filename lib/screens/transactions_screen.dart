import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_list_item.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = _getFilteredTransactions(
      transactionProvider.transactions,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              const PopupMenuItem(value: 'Income', child: Text('Income')),
              const PopupMenuItem(value: 'Expense', child: Text('Expenses')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    _selectedFilter,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Dismissible(
                  key: Key(transaction.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Transaction'),
                        content: const Text(
                          'Are you sure you want to delete this transaction?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'DELETE',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    await transactionProvider.deleteTransaction(transaction.id);
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: const Text('Transaction deleted'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              transactionProvider.undoDelete();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: TransactionListItem(
                    transaction: transaction,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTransactionScreen(
                            transaction: transaction,
                          ),
                        ),
                      );
                    },
                    onDelete: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Transaction'),
                          content: const Text(
                            'Are you sure you want to delete this transaction?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'DELETE',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && mounted) {
                        await transactionProvider.deleteTransaction(
                          transaction.id,
                        );
                        if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: const Text('Transaction deleted'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  transactionProvider.undoDelete();
                                },
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<TransactionModel> _getFilteredTransactions(
    List<TransactionModel> transactions,
  ) {
    final sorted = List<TransactionModel>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    switch (_selectedFilter) {
      case 'Income':
        return sorted
            .where((t) => t.type == TransactionType.income)
            .toList();
      case 'Expense':
        return sorted
            .where((t) => t.type == TransactionType.expense)
            .toList();
      default:
        return sorted;
    }
  }
}
