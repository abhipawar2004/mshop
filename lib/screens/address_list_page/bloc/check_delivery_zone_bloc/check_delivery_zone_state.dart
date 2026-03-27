part of 'check_delivery_zone_bloc.dart';

abstract class CheckDeliveryZoneState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckDeliveryZoneInitial extends CheckDeliveryZoneState {}

class CheckDeliveryZoneProgress extends CheckDeliveryZoneState {}

class CheckDeliveryZoneSuccess extends CheckDeliveryZoneState {
  final String message;
  CheckDeliveryZoneSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class CheckDeliveryZoneFailure extends CheckDeliveryZoneState {
  final String error;
  CheckDeliveryZoneFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
