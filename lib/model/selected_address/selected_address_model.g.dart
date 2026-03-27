// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectedAddressAdapter extends TypeAdapter<SelectedAddress> {
  @override
  final int typeId = 2;

  @override
  SelectedAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectedAddress(
      id: fields[0] as int?,
      userId: fields[1] as int?,
      addressLine1: fields[2] as String?,
      addressLine2: fields[3] as String?,
      city: fields[4] as String?,
      landmark: fields[5] as String?,
      state: fields[6] as String?,
      zipcode: fields[7] as String?,
      mobile: fields[8] as String?,
      addressType: fields[9] as String?,
      country: fields[10] as String?,
      countryCode: fields[11] as String?,
      latitude: fields[12] as String?,
      longitude: fields[13] as String?,
      createdAt: fields[14] as String?,
      updatedAt: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SelectedAddress obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.addressLine1)
      ..writeByte(3)
      ..write(obj.addressLine2)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.landmark)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.zipcode)
      ..writeByte(8)
      ..write(obj.mobile)
      ..writeByte(9)
      ..write(obj.addressType)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.countryCode)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
