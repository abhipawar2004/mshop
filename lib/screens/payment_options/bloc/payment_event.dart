import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hyper_local/config/payment_config.dart';

abstract class PaymentEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final PaymentMethodType paymentMethodType;
  final double amount;
  final Map<String, dynamic>? additionalData;
  final bool addMoneyToWallet;
  final String? description;
  final BuildContext context;

  InitiatePaymentEvent({
    required this.paymentMethodType,
    required this.amount,
    this.additionalData,
    required this.addMoneyToWallet,
    this.description,
    required this.context
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    paymentMethodType, amount, additionalData,
    additionalData,
    description,
    context
  ];
}

class VerifyPaymentEvent extends PaymentEvent {
  final String transactionId;
  final String orderId;

  VerifyPaymentEvent({
    required this.transactionId,
    required this.orderId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [transactionId, orderId];
}

class ResetPaymentEvent extends PaymentEvent {}