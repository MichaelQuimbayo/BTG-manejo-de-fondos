// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FundModelAdapter extends TypeAdapter<FundModel> {
  @override
  final int typeId = 0;

  @override
  FundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FundModel(
      id: fields[0] as String,
      name: fields[1] as String,
      minimumAmount: fields[2] as double,
      category: fields[3] as String,
      isSubscribed: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FundModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.minimumAmount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.isSubscribed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
