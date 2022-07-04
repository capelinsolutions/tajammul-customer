// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveProduct.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductAdapter extends TypeAdapter<HiveProduct> {
  @override
  final int typeId = 0;

  @override
  HiveProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProduct()
      ..cartData = (fields[0] as List?)?.cast<CartProduct>()
      ..categoryList = (fields[1] as List?)?.cast<String>()
      ..business = fields[2] as Business?
      ..categoryProduct = (fields[3] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>()))
      ..currentCategory = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, HiveProduct obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cartData)
      ..writeByte(1)
      ..write(obj.categoryList)
      ..writeByte(2)
      ..write(obj.business)
      ..writeByte(3)
      ..write(obj.categoryProduct)
      ..writeByte(4)
      ..write(obj.currentCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
