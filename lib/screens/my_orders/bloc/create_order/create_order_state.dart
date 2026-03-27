part of 'create_order_bloc.dart';

abstract class CreateOrderState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderProgress extends CreateOrderState {}

class CreateOrderSuccess extends CreateOrderState {
  final String message;
  final String orderSlug;
  final String? paymentUrl;

  CreateOrderSuccess({required this.message, required this.orderSlug, required this.paymentUrl,});
  @override
  // TODO: implement props
  List<Object?> get props => [message, orderSlug, paymentUrl];
}

class CreateOrderFailure extends CreateOrderState {
  final String error;
  CreateOrderFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
