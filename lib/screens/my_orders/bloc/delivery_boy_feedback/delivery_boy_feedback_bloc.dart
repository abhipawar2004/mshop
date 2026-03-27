import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/my_orders/repo/delivery_boy_feedback_repo.dart';

part 'delivery_boy_feedback_event.dart';
part 'delivery_boy_feedback_state.dart';

class DeliveryBoyFeedbackBloc extends Bloc<DeliveryBoyFeedbackEvent, DeliveryBoyFeedbackState> {
  DeliveryBoyFeedbackBloc() : super(DeliveryBoyFeedbackInitial()) {
    on<AddDeliveryBoyFeedback>(_onAddDeliveryBoyFeedback);
    on<UpdateDeliveryBoyFeedback>(_onUpdateDeliveryBoyFeedback);
    on<DeleteDeliveryBoyFeedback>(_onDeleteDeliveryBoyFeedback);
  }
  final DeliveryBoyFeedbackRepo repository = DeliveryBoyFeedbackRepo();

  Future<void> _onAddDeliveryBoyFeedback(AddDeliveryBoyFeedback event, Emitter<DeliveryBoyFeedbackState> emit ) async {
    emit(DeliveryBoyFeedbackLoading());
    try{
      final response = await repository.addDeliveryFeedback(
        deliveryBoyId: event.deliveryBoyId,
        orderId: event.orderId,
        title: event.title,
        description: event.description,
        rating: event.rating
      );

      if(response['success'] == true){
        emit(DeliveryBoyFeedbackLoaded());
      } else {
        emit(DeliveryBoyFeedbackFailure(error: response['message']));
      }
    }catch(e) {
      emit(DeliveryBoyFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateDeliveryBoyFeedback(UpdateDeliveryBoyFeedback event, Emitter<DeliveryBoyFeedbackState> emit ) async {
    emit(DeliveryBoyFeedbackLoading());
    try{
      final response = await repository.updateDeliveryFeedback(
        feedbackId: event.feedbackId,
        title: event.title,
        description: event.description,
        rating: event.rating,
      );

      if(response['success'] == true){
        emit(DeliveryBoyFeedbackLoaded());
      } else {
        emit(DeliveryBoyFeedbackFailure(error: response['message'] ?? 'Failed to update feedback'));
      }
    }catch(e) {
      emit(DeliveryBoyFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteDeliveryBoyFeedback(DeleteDeliveryBoyFeedback event, Emitter<DeliveryBoyFeedbackState> emit ) async {
    emit(DeliveryBoyFeedbackLoading());
    try{
      final response = await repository.deleteDeliveryFeedback(
        feedbackId: event.feedbackId,
      );

      if(response['success'] == true){
        emit(DeliveryBoyFeedbackLoaded());
      } else {
        emit(DeliveryBoyFeedbackFailure(error: response['message'] ?? 'Failed to delete feedback'));
      }
    }catch(e) {
      emit(DeliveryBoyFeedbackFailure(error: e.toString()));
    }
  }
}
