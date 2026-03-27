part of 'check_delivery_zone_bloc.dart';

abstract class CheckDeliveryZoneEvent  extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckDeliveryZoneRequest extends CheckDeliveryZoneEvent{
  final String latitude;
  final String longitude;

  CheckDeliveryZoneRequest({
    required this.latitude,
    required this.longitude,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    latitude,
    longitude
  ];
}
