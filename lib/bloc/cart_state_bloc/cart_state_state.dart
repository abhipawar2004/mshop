part of 'cart_state_bloc.dart';

abstract class CartStateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartStateInitial extends CartStateState {}

class CartStateUpdated extends CartStateState {
  final bool showViewCart;
  final int itemCount;
  final String? itemText;
  final bool hasAnimationBeenShown;

  CartStateUpdated({
    required this.showViewCart,
    required this.itemCount,
    this.itemText,
    this.hasAnimationBeenShown = false,
  });

  @override
  List<Object?> get props => [showViewCart, itemCount, itemText, hasAnimationBeenShown];
}
