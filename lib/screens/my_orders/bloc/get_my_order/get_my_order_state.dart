import 'package:equatable/equatable.dart';

import '../../model/my_order_model.dart';

abstract class GetMyOrderState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetMyOrderInitial extends GetMyOrderState {}

class GetMyOrderLoading extends GetMyOrderState {}

class GetMyOrderLoaded extends GetMyOrderState {
  final List<MyOrdersData> myOrderData;
  final String message;
  final bool hasReachedMax;

  GetMyOrderLoaded({
    required this.message,
    required this.myOrderData,
    required this.hasReachedMax,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, myOrderData, hasReachedMax];
}

class GetMyOrderFailed extends GetMyOrderState {
  final String error;

  GetMyOrderFailed({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}