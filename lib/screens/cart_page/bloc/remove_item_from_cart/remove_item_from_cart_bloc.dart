import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/cart_repository.dart';
import 'remove_item_from_cart_event.dart';
import 'remove_item_from_cart_state.dart';


class RemoveItemFromCartBloc extends Bloc<RemoveItemFromCartEvent, RemoveItemFromCartState> {
  RemoveItemFromCartBloc() : super(RemoveItemFromCartInitial()) {
    on<RemoveItemFromCartRequest>(_onRemoveItemFromCartRequest);
  }

  final CartRepository repository = CartRepository();

  Future<void> _onRemoveItemFromCartRequest(RemoveItemFromCartRequest event, Emitter<RemoveItemFromCartState> emit) async {
    emit(RemoveItemFromCartLoading());
    try{
      final response = await repository.removeItemFromCart(
        cartItemId: event.cartItemId,
      );
      if(response['success']== true){
        emit(RemoveItemFromCartSuccess());
      } else {
        emit(RemoveItemFromCartFailed(error: response['message']));
      }
    }catch(e){
      emit(RemoveItemFromCartFailed(error: e.toString()));
    }
  }
}
