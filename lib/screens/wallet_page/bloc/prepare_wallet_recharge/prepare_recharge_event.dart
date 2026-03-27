part of 'prepare_recharge_bloc.dart';

abstract class PrepareRechargeEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PrepareRecharge extends PrepareRechargeEvent {
  final String amount;
  final String paymentMethod;
  final String description;

  PrepareRecharge({required this.amount, required this.paymentMethod, required this.description});

  @override
  // TODO: implement props
  List<Object?> get props => [amount, paymentMethod, description];
}