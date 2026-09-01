import 'package:hive/hive.dart';
import 'package:fintrack/domain/entities/budget.dart';

part 'budget_hive_model.g.dart';

@HiveType(typeId: 2)
class BudgetHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late int amount;

  @HiveField(3)
  late int month;

  @HiveField(4)
  late int year;

  BudgetHiveModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  factory BudgetHiveModel.fromEntity(Budget entity) {
    return BudgetHiveModel(
      id: entity.id,
      category: entity.category,
      amount: entity.amount,
      month: entity.month,
      year: entity.year,
    );
  }

  Budget toEntity() {
    return Budget(
      id: id,
      category: category,
      amount: amount,
      month: month,
      year: year,
    );
  }
}