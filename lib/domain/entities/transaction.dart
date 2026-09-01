import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class Transaction extends Equatable {
  final String id;
  final String title;
  final int amount; // stored in minor units (paise/cents)
  final DateTime date;
  final String category;
  final TransactionType type;
  final String? description;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.description,
  });

  double get amountInMajorUnits => amount / 100.0;

  String get formattedAmount => '₹${amountInMajorUnits.toStringAsFixed(2)}';

  String get signedAmount =>
      '${type == TransactionType.income ? '+' : '-'}₹${amountInMajorUnits.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [id, title, amount, date, category, type, description];

  Transaction copyWith({
    String? id,
    String? title,
    int? amount,
    DateTime? date,
    String? category,
    TransactionType? type,
    String? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}

class TransactionCategories {
  static const List<String> expenseCategories = [
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Gift',
    'Other',
  ];

  static List<String> categoriesForType(TransactionType type) {
    return type == TransactionType.income
        ? incomeCategories
        : expenseCategories;
  }
}