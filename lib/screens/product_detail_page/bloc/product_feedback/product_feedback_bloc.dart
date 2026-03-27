import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../repo/product_feedback_repo.dart';

part 'product_feedback_event.dart';
part 'product_feedback_state.dart';

class ProductFeedbackBloc extends Bloc<ProductFeedbackEvent, ProductFeedbackState> {
  ProductFeedbackBloc() : super(ProductFeedbackInitial()) {
    on<AddProductFeedback>(_onAddProductFeedback);
    on<UpdateProductFeedback>(_onUpdateProductFeedback);
    on<DeleteProductFeedback>(_onDeleteProductFeedback);
    on<ResetProductFeedback>(_onResetProductFeedback);
  }
  final ProductFeedbackRepo repository = ProductFeedbackRepo();

  Future<void> _onAddProductFeedback(
      AddProductFeedback event,
      Emitter<ProductFeedbackState> emit,
      ) async {
    emit(ProductFeedbackLoading());
    try {
      final response = await repository.addProductFeedback(
        orderItemId: event.orderItemId,
        title: event.title,
        description: event.description,
        rating: event.rating,
        images: event.images
      );

      if (response['success'] == true) {
        emit(ProductFeedbackLoaded());
      } else {
        emit(ProductFeedbackFailure(error: response['message'] ?? 'Failed to submit feedback'));
      }
    } catch (e) {
      emit(ProductFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateProductFeedback(
      UpdateProductFeedback event,
      Emitter<ProductFeedbackState> emit,
      ) async {
    emit(ProductFeedbackLoading());
    try {

      final response = await repository.updateProductFeedback(
        feedbackId: event.feedbackId,
        title: event.title,
        description: event.description,
        rating: event.rating,
      );

      if (response['success'] == true) {
        emit(ProductFeedbackLoaded());
      } else {
        emit(ProductFeedbackFailure(
          error: response['message'] ?? 'Failed to update feedback',
        ));
      }
    } catch (e) {
      emit(ProductFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteProductFeedback(
      DeleteProductFeedback event,
      Emitter<ProductFeedbackState> emit,
      ) async {
    emit(ProductFeedbackLoading());
    try {
      final response = await repository.deleteProductFeedback(
        feedbackId: event.feedbackId,
      );

      if (response['success'] == true) {
        emit(ProductFeedbackLoaded());
      } else {
        emit(ProductFeedbackFailure(
          error: response['message'] ?? 'Failed to delete feedback',
        ));
      }
    } catch (e) {
      emit(ProductFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onResetProductFeedback(
      ResetProductFeedback event,
      Emitter<ProductFeedbackState> emit,
      ) async {
    emit(ProductFeedbackInitial());
  }
}







































/*
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/product_feedback_repo.dart';

part 'product_feedback_event.dart';
part 'product_feedback_state.dart';

class ProductFeedbackBloc extends Bloc<ProductFeedbackEvent, ProductFeedbackState> {
  ProductFeedbackBloc() : super(ProductFeedbackInitial()) {
    on<AddProductFeedback>(_onAddProductFeedback);
    on<UpdateProductFeedback>(_onUpdateProductFeedback);
    on<DeleteProductFeedback>(_onDeleteProductFeedback);
  }
  final ProductFeedbackRepo repository = ProductFeedbackRepo();

  Future<void> _onAddProductFeedback(AddProductFeedback event, Emitter<ProductFeedbackState> emit ) async {
    emit(ProductFeedbackLoading());
    try{
      final response = await repository.addProductFeedback(
        productId: event.productId,
        title: event.title,
        description: event.description,
        rating: event.rating
      );

      if(response['success'] == true){
        emit(ProductFeedbackLoaded());
      } else {
        emit(ProductFeedbackFailure(error: response['message']));
      }
    }catch(e) {
      emit(ProductFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateProductFeedback(UpdateProductFeedback event, Emitter<ProductFeedbackState> emit ) async {
    emit(ProductFeedbackLoading());
    try{
      final response = await repository.updateProductFeedback(
        feedbackId: event.feedbackId,
        title: event.title,
        description: event.description,
        rating: event.rating,
      );

      if(response['success'] == true){
        emit(ProductFeedbackLoaded());
      } else {
        emit(ProductFeedbackFailure(error: response['message'] ?? 'Failed to update feedback'));
      }
    }catch(e) {
      emit(ProductFeedbackFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteProductFeedback(DeleteProductFeedback event, Emitter<ProductFeedbackState> emit ) async {
    emit(ProductFeedbackLoading());
    try{
      final response = await repository.deleteProductFeedback(
        feedbackId: event.feedbackId,
      );

      if(response['success'] == true){
        emit(ProductFeedbackLoaded());
      } else {
        emit(ProductFeedbackFailure(error: response['message'] ?? 'Failed to delete feedback'));
      }
    }catch(e) {
      emit(ProductFeedbackFailure(error: e.toString()));
    }
  }
}
*/
