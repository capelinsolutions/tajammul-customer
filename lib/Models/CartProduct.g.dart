// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CartProduct.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartProductAdapter extends TypeAdapter<CartProduct> {
  @override
  final int typeId = 2;

  @override
  CartProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartProduct(
      productName: fields[0] as String?,
      quantity: fields[1] as int?,
      price: fields[2] as int?,
      discount: fields[4] as int?,
      discountedPrice: fields[3] as int?,
      imagePaths: (fields[8] as List?)?.cast<dynamic>(),
      errorType: fields[5] as String?,
      updatedStock: fields[6] as int?,
      previousQuantity: fields[7] as int?,
      listImagePath: (fields[9] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartProduct obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.discountedPrice)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.errorType)
      ..writeByte(6)
      ..write(obj.updatedStock)
      ..writeByte(7)
      ..write(obj.previousQuantity)
      ..writeByte(8)
      ..write(obj.imagePaths)
      ..writeByte(9)
      ..write(obj.listImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
