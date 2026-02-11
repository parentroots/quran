// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HadithBookAdapter extends TypeAdapter<HadithBook> {
  @override
  final int typeId = 2;

  @override
  HadithBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HadithBook(
      id: fields[0] as String,
      name: fields[1] as String,
      writerName: fields[2] as String,
      numberOfHadith: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HadithBook obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.writerName)
      ..writeByte(3)
      ..write(obj.numberOfHadith);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HadithAdapter extends TypeAdapter<Hadith> {
  @override
  final int typeId = 3;

  @override
  Hadith read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hadith(
      id: fields[0] as String,
      bookId: fields[1] as String,
      hadithNumber: fields[2] as int,
      text: fields[3] as String,
      narrator: fields[4] as String,
      category: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Hadith obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.hadithNumber)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.narrator)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
