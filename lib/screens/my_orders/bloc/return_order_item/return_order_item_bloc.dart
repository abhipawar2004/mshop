import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/my_orders/repo/order_repo.dart';
import 'package:image_picker/image_picker.dart';

part 'return_order_item_event.dart';
part 'return_order_item_state.dart';

class ReturnOrderItemBloc extends Bloc<ReturnOrderItemEvent, ReturnOrderItemState> {
  ReturnOrderItemBloc() : super(ReturnOrderItemInitial()) {
    on<ReturnOrderItemRequest>(_onReturnOrderItemRequest);
    on<CancelReturnRequest>(_onCancelReturnRequest);
    on<CancelOrderItem>(_onCancelOrderItem);
  }

  final OrderRepository repository = OrderRepository();

  Future<void> _onReturnOrderItemRequest(ReturnOrderItemRequest event, Emitter<ReturnOrderItemState> emit) async {
    emit(ReturnOrderItemLoading());
    try{
      final response = await repository.returnOrderItemRequest(
        orderItemId: event.orderItemId,
        reason: event.reason,
        images: event.images
      );

      if(response['success'] == true) {
        emit(ReturnOrderItemSuccess(message: response['message']));
      } else {
        emit(ReturnOrderItemFailed(error: response['message'].toString()));
      }
    }catch(e){
      emit(ReturnOrderItemFailed(error: e.toString()));
    }
  }

  Future<void> _onCancelReturnRequest(CancelReturnRequest event, Emitter<ReturnOrderItemState> emit) async {
    emit(ReturnOrderItemLoading());
    try{
      final response = await repository.cancelReturnRequest(
        orderItemId: event.orderItemId,
      );
      if(response['success'] == true) {
        emit(ReturnOrderItemSuccess(message: response['message']));
      } else {
        emit(ReturnOrderItemFailed(error: response['message'].toString()));
      }
    }catch(e){
      emit(ReturnOrderItemFailed(error: e.toString()));
    }
  }

  Future<void> _onCancelOrderItem(CancelOrderItem event, Emitter<ReturnOrderItemState> emit) async {
    emit(ReturnOrderItemLoading());
    try{
      final response = await repository.cancelOrderItem(
        orderItemId: event.orderItemId,
      );
      if(response['success'] == true) {
        emit(ReturnOrderItemSuccess(message: response['message']));
      } else {
        emit(ReturnOrderItemFailed(error: response['message'].toString()));
      }
    }catch(e){
      emit(ReturnOrderItemFailed(error: e.toString()));
    }
  }
}
