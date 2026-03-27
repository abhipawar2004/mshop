
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state_event.dart';
part 'cart_state_state.dart';

class CartStateBloc extends Bloc<CartStateEvent, CartStateState> {
  CartStateBloc() : super(CartStateInitial()) {
    on<UpdateCartVisibility>(_onUpdateCartVisibility);
    on<UpdateCartItemCount>(_onUpdateCartItemCount);
    on<UpdateCartItemText>(_onUpdateCartItemText);
    on<ResetCartState>(_onResetCartState);
    on<MarkAnimationAsShown>(_onMarkAnimationAsShown);
  }

  void _onUpdateCartVisibility(UpdateCartVisibility event, Emitter<CartStateState> emit) {
    emit(CartStateUpdated(
      showViewCart: event.showViewCart,
      itemCount: state is CartStateUpdated ? (state as CartStateUpdated).itemCount : 0,
      itemText: state is CartStateUpdated ? (state as CartStateUpdated).itemText : null,
      hasAnimationBeenShown: state is CartStateUpdated ? (state as CartStateUpdated).hasAnimationBeenShown : false,
    ));
  }

  void _onUpdateCartItemCount(UpdateCartItemCount event, Emitter<CartStateState> emit) {
    emit(CartStateUpdated(
      showViewCart: state is CartStateUpdated ? (state as CartStateUpdated).showViewCart : true,
      itemCount: event.itemCount,
      itemText: state is CartStateUpdated ? (state as CartStateUpdated).itemText : null,
      hasAnimationBeenShown: state is CartStateUpdated ? (state as CartStateUpdated).hasAnimationBeenShown : false,
    ));
  }

  void _onUpdateCartItemText(UpdateCartItemText event, Emitter<CartStateState> emit) {
    emit(CartStateUpdated(
      showViewCart: state is CartStateUpdated ? (state as CartStateUpdated).showViewCart : true,
      itemCount: state is CartStateUpdated ? (state as CartStateUpdated).itemCount : 0,
      itemText: event.itemText,
      hasAnimationBeenShown: state is CartStateUpdated ? (state as CartStateUpdated).hasAnimationBeenShown : false,
    ));
  }

  void _onResetCartState(ResetCartState event, Emitter<CartStateState> emit) {
    emit(CartStateInitial());
  }

  void _onMarkAnimationAsShown(MarkAnimationAsShown event, Emitter<CartStateState> emit) {
    if (state is CartStateUpdated) {
      final currentState = state as CartStateUpdated;
      emit(CartStateUpdated(
        showViewCart: currentState.showViewCart,
        itemCount: currentState.itemCount,
        itemText: currentState.itemText,
        hasAnimationBeenShown: true,
      ));
    }
  }
}
