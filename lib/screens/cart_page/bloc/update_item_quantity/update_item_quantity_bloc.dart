import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/cart_repository.dart';
import 'update_item_quantity_event.dart';
import 'update_item_quantity_state.dart';


class UpdateItemQuantityBloc extends Bloc<UpdateItemQuantityEvent, UpdateItemQuantityState> {
  UpdateItemQuantityBloc() : super(UpdateItemQuantityInitial()) {
    on<UpdateItemQuantityRequest>(_onUpdateItemQuantityRequest);
  }

  final CartRepository repository = CartRepository();

  Future<void> _onUpdateItemQuantityRequest(UpdateItemQuantityRequest event, Emitter<UpdateItemQuantityState> emit) async {

    emit(UpdateItemQuantityLoading());
    try{
      final response = await repository.updateItemQuantity(
        cartItemId: event.cartItemId,
        quantity: event.quantity
      );
      if(response['success'] == true) {
        emit(UpdateItemQuantitySuccess());
      }
      else {
        emit(UpdateItemQuantityFailed(error: response['message']));
      }
    }catch(e){
      emit(UpdateItemQuantityFailed(error: e.toString()));
    }
  }
}
