import 'package:hive/hive.dart';
import 'package:fintrack/domain/entities/transaction.dart';

part 'transaction_hive_model.g.dart';

@HiveType(typeId: 0)
class TransactionHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late int amount;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late int type; // 0 = income, 1 = expense

  @HiveField(6)
  String? description;

  TransactionHiveModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.description,
  });

  factory TransactionHiveModel.fromEntity(Transaction entity) {
    return TransactionHiveModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      date: entity.date,
      category: entity.category,
      type: entity.type == TransactionType.income ? 0 : 1,
      description: entity.description,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: category,
      type: type == 0 ? TransactionType.income : TransactionType.expense,
      description: description,
    );
  }
}

@HiveType(typeId: 1)
enum TransactionTypeHive {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}