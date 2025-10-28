import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late int month; // 1-12

  @HiveField(4)
  late int year;

  BudgetModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  BudgetModel copyWith({
    String? id,
    String? category,
    double? amount,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }
}
