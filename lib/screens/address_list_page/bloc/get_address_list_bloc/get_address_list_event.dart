part of 'get_address_list_bloc.dart';

abstract class GetAddressListEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchUserAddressList extends GetAddressListEvent {
  final int? deliveryZoneId;
  FetchUserAddressList({this.deliveryZoneId});
  @override
  // TODO: implement props
  List<Object?> get props => [deliveryZoneId];
}

class RemoveAddressLocally extends GetAddressListEvent {
  final int addressId;
  RemoveAddressLocally({required this.addressId});
  @override
  // TODO: implement props
  List<Object?> get props => [addressId];
}

class AddAddressRequest extends GetAddressListEvent{
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String landmark;
  final String state;
  final String zipcode;
  final String mobile;
  final String addressType;
  final String country;
  final String countryCode;
  final String latitude;
  final String longitude;
  final int? deliveryZoneId;

  AddAddressRequest({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.landmark,
    required this.state,
    required this.zipcode,
    required this.mobile,
    required this.addressType,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.deliveryZoneId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    addressLine1,
    addressLine2,
    city,
    landmark,
    state,
    zipcode,
    mobile,
    addressType,
    country,
    countryCode,
    latitude,
    longitude,
    deliveryZoneId
  ];
}

class UpdateAddressRequest extends GetAddressListEvent {
  final int addressId;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String landmark;
  final String state;
  final String zipcode;
  final String mobile;
  final String addressType;
  final String country;
  final String countryCode;
  final String latitude;
  final String longitude;

  UpdateAddressRequest({
    required this.addressId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.landmark,
    required this.state,
    required this.zipcode,
    required this.mobile,
    required this.addressType,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    addressId,
    addressLine1,
    addressLine2,
    city,
    landmark,
    state,
    zipcode,
    mobile,
    addressType,
    country,
    countryCode,
    latitude,
    longitude
  ];
}

class RemoveAddressRequest extends GetAddressListEvent {
  final int addressId;

  RemoveAddressRequest({required this.addressId});

  @override
  // TODO: implement props
  List<Object?> get props => [addressId];
}