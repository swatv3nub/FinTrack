// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetHiveModelAdapter extends TypeAdapter<BudgetHiveModel> {
  @override
  final int typeId = 2;

  @override
  BudgetHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetHiveModel(
      id: fields[0] as String,
      category: fields[1] as String,
      amount: fields[2] as int,
      month: fields[3] as int,
      year: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.month)
      ..writeByte(4)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
