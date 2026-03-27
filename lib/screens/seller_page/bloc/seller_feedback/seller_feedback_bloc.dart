import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/seller_feedback_repo.dart';
part 'seller_feedback_event.dart';
part 'seller_feedback_state.dart';

class SellerFeedbackBloc extends Bloc<SellerFeedbackEvent, SellerFeedbackState> {
  SellerFeedbackBloc() : super(SellerFeedbackInitial()) {
    on<AddSellerFeedback>(_onAddSellerFeedback);
    on<UpdateSellerFeedback>(_onUpdateSellerFeedback);
    on<DeleteSellerFeedback>(_onDeleteSellerFeedback);
    on<ResetSellerFeedback>((event, emit) => emit(SellerFeedbackInitial()));
  }
  final SellerFeedbackRepo repository = SellerFeedbackRepo();

  Future<void> _onAddSellerFeedback(AddSellerFeedback event, Emitter<SellerFeedbackState> emit ) async {
    emit(SellerFeedbackLoading());
    try{
      final response = await repository.addSellerFeedback(
        orderItemId: event.orderItemId,
        sellerId: event.sellerId,
        title: event.title,
        description: event.description,
        rating: event.rating
      );

      if(response['success'] == true){
        emit(SellerFeedbackLoaded());
      } else {
        emit(SellerFeedbackFailure(error: response['message']));
      }
    }catch(e) {
      emit(SellerFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateSellerFeedback(UpdateSellerFeedback event, Emitter<SellerFeedbackState> emit ) async {
    emit(SellerFeedbackLoading());
    try{
      final response = await repository.updateSellerFeedback(
        feedbackId: event.feedbackId,
        title: event.title,
        description: event.description,
        rating: event.rating,
      );

      if(response['success'] == true){
        emit(SellerFeedbackLoaded());
      } else {
        emit(SellerFeedbackFailure(error: response['message'] ?? 'Failed to update feedback'));
      }
    }catch(e) {
      emit(SellerFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteSellerFeedback(DeleteSellerFeedback event, Emitter<SellerFeedbackState> emit ) async {
    emit(SellerFeedbackLoading());
    try{
      final response = await repository.deleteSellerFeedback(
        feedbackId: event.feedbackId,
      );

      if(response['success'] == true){
        emit(SellerFeedbackLoaded());
      } else {
        emit(SellerFeedbackFailure(error: response['message'] ?? 'Failed to delete feedback'));
      }
    }catch(e) {
      emit(SellerFeedbackFailure(error: e.toString()));
    }
  }
}