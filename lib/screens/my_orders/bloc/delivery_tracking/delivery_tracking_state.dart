part of 'delivery_tracking_bloc.dart';

abstract class DeliveryTrackingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryTrackingInitial extends DeliveryTrackingState {}

class DeliveryTrackingLoading extends DeliveryTrackingState {}

class DeliveryTrackingLoaded extends DeliveryTrackingState {
  final DeliveryBoyTrackingModel tracking;
  final String message;

  DeliveryTrackingLoaded({
    required this.tracking,
    required this.message,
  });

  @override
  List<Object?> get props => [tracking, message];
}

class DeliveryTrackingFailed extends DeliveryTrackingState {
  final String error;

  DeliveryTrackingFailed({required this.error});

  @override
  List<Object?> get props => [error];
}


