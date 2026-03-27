part of 'cart_state_bloc.dart';

abstract class CartStateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateCartVisibility extends CartStateEvent {
  final bool showViewCart;

  UpdateCartVisibility({
    required this.showViewCart,
  });

  @override
  List<Object?> get props => [showViewCart];
}

class UpdateCartItemCount extends CartStateEvent {
  final int itemCount;

  UpdateCartItemCount({required this.itemCount});

  @override
  List<Object?> get props => [itemCount];
}

class UpdateCartItemText extends CartStateEvent {
  final String? itemText;

  UpdateCartItemText({this.itemText});

  @override
  List<Object?> get props => [itemText];
}

class ResetCartState extends CartStateEvent {}

class MarkAnimationAsShown extends CartStateEvent {}
