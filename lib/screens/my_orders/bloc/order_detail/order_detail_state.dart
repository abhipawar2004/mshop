part of 'order_detail_bloc.dart';

abstract class OrderDetailState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final List<OrderDetailModel> cartData;
  final String message;
  OrderDetailLoaded({required this.cartData, required this.message,});
  @override
  // TODO: implement props
  List<Object?> get props => [cartData, message];
}

class OrderDetailFailed extends OrderDetailState {
  final String error;
  OrderDetailFailed({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}