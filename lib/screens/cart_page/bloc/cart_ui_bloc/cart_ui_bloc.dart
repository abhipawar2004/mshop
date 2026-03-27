import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_ui_event.dart';
import 'cart_ui_state.dart';

class CartUIBloc extends Bloc<CartUIEvent, CartUIState> {
  CartUIBloc() : super(const CartUIState()) {
    on<SetSelectedAddress>((event, emit) {
      emit(state.copyWith(selectedAddress: event.address));
    });

    on<SetDeliveryType>((event, emit) {
      emit(state.copyWith(selectedDeliveryType: event.type));
    });

    on<SetWalletUsage>((event, emit) {
      emit(state.copyWith(useWallet: event.useWallet));
    });

    on<SetPaymentMethod>((event, emit) {
      emit(state.copyWith(
        selectedPaymentMethod: event.paymentMethodId,
        selectedPaymentMethodType: event.paymentMethodType,
      ));
    });

    on<SetTotalAmount>((event, emit) {
      emit(state.copyWith(totalAmount: event.amount));
    });

    on<SetCartLoading>((event, emit) {
      emit(state.copyWith(isCartLoading: event.isLoading));
    });

    on<SetWalletLoading>((event, emit) {
      emit(state.copyWith(isWalletLoading: event.isLoading));
    });

    on<SetWholePageProgress>((event, emit) {
      emit(state.copyWith(isWholePageProgress: event.show));
    });
  }
}
