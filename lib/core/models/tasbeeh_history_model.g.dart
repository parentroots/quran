// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbeeh_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasbeehHistoryAdapter extends TypeAdapter<TasbeehHistory> {
  @override
  final int typeId = 4;

  @override
  TasbeehHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbeehHistory(
      dhikr: fields[0] as String,
      count: fields[1] as int,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TasbeehHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dhikr)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbeehHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
