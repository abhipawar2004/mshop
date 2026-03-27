
import 'package:equatable/equatable.dart';
import 'package:hyper_local/model/user_cart_model/user_cart.dart';

abstract class CartState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<UserCart> items;
  final String? errorMessage;

  CartLoaded(this.items, {this.errorMessage});

  @override
  List<Object?> get props => items
      .map((e) =>
          '${e.productId}_${e.variantId}_${e.quantity}_${e.syncAction}_${e.isSynced}')
      .toList();

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.totalPrice);
}

class CartError extends CartState {
  final String error;
  CartError({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
