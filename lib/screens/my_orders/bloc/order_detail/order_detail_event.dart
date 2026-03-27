part of 'order_detail_bloc.dart';

abstract class OrderDetailEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchOrderDetail extends OrderDetailEvent {
  final String orderSlug;

  FetchOrderDetail({
    required this.orderSlug,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [orderSlug];
}
