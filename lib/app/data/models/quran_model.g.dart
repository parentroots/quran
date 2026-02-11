// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahAdapter extends TypeAdapter<Surah> {
  @override
  final int typeId = 0;

  @override
  Surah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Surah(
      number: fields[0] as int,
      name: fields[1] as String,
      englishName: fields[2] as String,
      englishNameTranslation: fields[3] as String,
      numberOfAyahs: fields[4] as int,
      revelationType: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Surah obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.englishName)
      ..writeByte(3)
      ..write(obj.englishNameTranslation)
      ..writeByte(4)
      ..write(obj.numberOfAyahs)
      ..writeByte(5)
      ..write(obj.revelationType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AyahAdapter extends TypeAdapter<Ayah> {
  @override
  final int typeId = 1;

  @override
  Ayah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ayah(
      number: fields[0] as int,
      text: fields[1] as String,
      numberInSurah: fields[2] as int,
      juz: fields[3] as int,
      manzil: fields[4] as int,
      page: fields[5] as int,
      ruku: fields[6] as int,
      hizbQuarter: fields[7] as int,
      sajda: fields[8] as int,
      translation: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Ayah obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.numberInSurah)
      ..writeByte(3)
      ..write(obj.juz)
      ..writeByte(4)
      ..write(obj.manzil)
      ..writeByte(5)
      ..write(obj.page)
      ..writeByte(6)
      ..write(obj.ruku)
      ..writeByte(7)
      ..write(obj.hizbQuarter)
      ..writeByte(8)
      ..write(obj.sajda)
      ..writeByte(9)
      ..write(obj.translation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
