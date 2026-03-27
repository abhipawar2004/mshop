import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/cart_repository.dart';
import 'clear_cart_event.dart';
import 'clear_cart_state.dart';

class ClearCartBloc extends Bloc<ClearCartEvent, ClearCartState> {
  ClearCartBloc() : super(ClearCartInitial()) {
    on<ClearCartRequest>(_onClearCartRequest);
  }

  final CartRepository repository = CartRepository();

  Future<void> _onClearCartRequest(ClearCartRequest event, Emitter<ClearCartState> emit) async {
    try{
      final response = await repository.clearCart();
      if(response['success']== true){
        emit(ClearCartSuccess());
      } else {
        emit(ClearCartFailed(error: response['message']));
      }
    }catch(e){
      emit(ClearCartFailed(error: e.toString()));
    }
  }
}
