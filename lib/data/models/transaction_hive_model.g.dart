// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionHiveModelAdapter extends TypeAdapter<TransactionHiveModel> {
  @override
  final int typeId = 0;

  @override
  TransactionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as int,
      date: fields[3] as DateTime,
      category: fields[4] as String,
      type: fields[5] as int,
      description: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeHiveAdapter extends TypeAdapter<TransactionTypeHive> {
  @override
  final int typeId = 1;

  @override
  TransactionTypeHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionTypeHive.income;
      case 1:
        return TransactionTypeHive.expense;
      default:
        return TransactionTypeHive.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionTypeHive obj) {
    switch (obj) {
      case TransactionTypeHive.income:
        writer.writeByte(0);
        break;
      case TransactionTypeHive.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
