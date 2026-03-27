import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/delivery_tracking_model.dart';
import '../../repo/order_repo.dart';

part 'delivery_tracking_event.dart';
part 'delivery_tracking_state.dart';

class DeliveryTrackingBloc extends Bloc<DeliveryTrackingEvent, DeliveryTrackingState> {
  DeliveryTrackingBloc() : super(DeliveryTrackingInitial()) {
    on<FetchDeliveryTracking>(_onFetchDeliveryTracking);
  }

  final OrderRepository repository = OrderRepository();

  Future<void> _onFetchDeliveryTracking(
      FetchDeliveryTracking event,
      Emitter<DeliveryTrackingState> emit,
  ) async {
    emit(DeliveryTrackingLoading());
    try {
      final tracking = await repository.getDeliveryTracking(orderSlug: event.orderSlug);
      if (tracking != null && tracking.success == true) {
        emit(DeliveryTrackingLoaded(
          tracking: tracking,
          message: tracking.message ?? '',
        ));
      } else {
        emit(DeliveryTrackingFailed(
          error: tracking?.message ?? 'Failed to load delivery tracking',
        ));
      }
    } catch (e) {
      emit(DeliveryTrackingFailed(error: e.toString()));
    }
  }
}


