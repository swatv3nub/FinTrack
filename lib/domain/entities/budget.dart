import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String category;
  final int amount; // stored in minor units
  final int month; // 1-12
  final int year;

  const Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  double get amountInMajorUnits => amount / 100.0;

  String get formattedAmount => '₹${amountInMajorUnits.toStringAsFixed(2)}';

  String get periodLabel {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month - 1]} $year';
  }

  @override
  List<Object?> get props => [id, category, amount, month, year];

  Budget copyWith({
    String? id,
    String? category,
    int? amount,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}

enum BudgetStatus {
  underBudget,
  approachingLimit,
  overBudget,
}

extension BudgetStatusExtension on BudgetStatus {
  String get label {
    switch (this) {
      case BudgetStatus.underBudget:
        return 'Under Budget';
      case BudgetStatus.approachingLimit:
        return 'Approaching Limit';
      case BudgetStatus.overBudget:
        return 'Over Budget';
    }
  }
}