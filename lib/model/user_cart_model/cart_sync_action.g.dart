// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_sync_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartSyncActionAdapter extends TypeAdapter<CartSyncAction> {
  @override
  final int typeId = 11;

  @override
  CartSyncAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CartSyncAction.none;
      case 1:
        return CartSyncAction.add;
      case 2:
        return CartSyncAction.update;
      case 3:
        return CartSyncAction.delete;
      default:
        return CartSyncAction.none;
    }
  }

  @override
  void write(BinaryWriter writer, CartSyncAction obj) {
    switch (obj) {
      case CartSyncAction.none:
        writer.writeByte(0);
        break;
      case CartSyncAction.add:
        writer.writeByte(1);
        break;
      case CartSyncAction.update:
        writer.writeByte(2);
        break;
      case CartSyncAction.delete:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartSyncActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
