part of 'delivery_tracking_bloc.dart';

abstract class DeliveryTrackingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDeliveryTracking extends DeliveryTrackingEvent {
  final String orderSlug;

  FetchDeliveryTracking({
    required this.orderSlug,
  });

  @override
  List<Object?> get props => [orderSlug];
}


