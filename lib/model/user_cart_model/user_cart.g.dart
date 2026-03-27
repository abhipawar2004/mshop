// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCartAdapter extends TypeAdapter<UserCart> {
  @override
  final int typeId = 10;

  @override
  UserCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCart(
      productId: fields[0] as String,
      variantId: fields[1] as String,
      variantName: fields[2] as String,
      vendorId: fields[3] as String,
      name: fields[4] as String,
      image: fields[5] as String,
      price: fields[6] as double,
      originalPrice: fields[7] as double,
      quantity: fields[8] as int,
      minQty: fields[9] as int,
      maxQty: fields[10] as int,
      isOutOfStock: fields[11] as bool,
      isSynced: fields[12] as bool,
      updatedAt: fields[13] as DateTime,
      serverCartItemId: fields[14] as int?,
      syncAction: fields[15] as CartSyncAction,
    );
  }

  @override
  void write(BinaryWriter writer, UserCart obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.variantId)
      ..writeByte(2)
      ..write(obj.variantName)
      ..writeByte(3)
      ..write(obj.vendorId)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.originalPrice)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.minQty)
      ..writeByte(10)
      ..write(obj.maxQty)
      ..writeByte(11)
      ..write(obj.isOutOfStock)
      ..writeByte(12)
      ..write(obj.isSynced)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.serverCartItemId)
      ..writeByte(15)
      ..write(obj.syncAction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
