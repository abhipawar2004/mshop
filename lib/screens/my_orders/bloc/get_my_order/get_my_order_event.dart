import 'package:equatable/equatable.dart';

abstract class GetMyOrderEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchMyOrder extends GetMyOrderEvent {}

class FetchMoreMyOrder extends GetMyOrderEvent {}

class RefreshMyOrders extends GetMyOrderEvent {}