import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/order_detail_model.dart';
import '../../repo/order_repo.dart';
part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  OrderDetailBloc() : super(OrderDetailInitial()) {
    on<FetchOrderDetail>(_onFetchUserCart);
  }

  final OrderRepository repository = OrderRepository();

  Future<void> _onFetchUserCart(FetchOrderDetail event, Emitter<OrderDetailState> emit) async {
    emit(OrderDetailLoading());
    try{
      final orderDetailData = await repository.getOrderDetail(
        orderSlug: event.orderSlug,
      );
      if(orderDetailData.first.success == true) {
        emit(OrderDetailLoaded(
          cartData: orderDetailData,
          message: orderDetailData.first.message ?? ''
        ));
      }
    }catch (e) {
      emit(OrderDetailFailed(error: e.toString()));
    }
  }

}