import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/payment_options/bloc/payment_event.dart';
import 'package:hyper_local/screens/payment_options/bloc/payment_state.dart';

import '../repo/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;
  final BuildContext context;

  PaymentBloc({required this.paymentRepository, required this.context,}) : super(PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<ResetPaymentEvent>(_onResetPayment);
  }

  bool isLoading = false;

  Future<void> _onInitiatePayment(InitiatePaymentEvent event, Emitter<PaymentState> emit,) async {
    emit(PaymentLoading());
    isLoading = true;
    try {
      final result = await paymentRepository.initiatePayment(
        context: event.context,
        paymentMethodType: event.paymentMethodType,
        amount: event.amount,
        additionalData: event.additionalData,
        addMoneyToWallet: event.addMoneyToWallet
      );

      if (result['success'] == true) {
        isLoading = false;
        emit(PaymentSuccess(
          transactionId: result['payment_id'] ?? '',
          message: result['message'] ?? 'Payment completed successfully',
          signature: result['signature'],
          orderId: result['order_id']
        ));
      } else {
        isLoading = false;
        emit(PaymentFailure(
          error: result['error'] ?? 'Payment failed. Please try again.',
        ));
      }
    } catch (e) {
      isLoading = false;
      emit(PaymentFailure(
        error: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  void _onResetPayment(
      ResetPaymentEvent event,
      Emitter<PaymentState> emit,
      ) {
    emit(PaymentInitial());
  }

}