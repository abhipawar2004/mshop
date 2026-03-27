part of 'return_order_item_bloc.dart';

abstract class ReturnOrderItemState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReturnOrderItemInitial extends ReturnOrderItemState {}

class ReturnOrderItemLoading extends ReturnOrderItemState {}

class ReturnOrderItemSuccess extends ReturnOrderItemState {
  final String message;
  ReturnOrderItemSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ReturnOrderItemFailed extends ReturnOrderItemState {
  final String error;
  ReturnOrderItemFailed({required this.error});
}
