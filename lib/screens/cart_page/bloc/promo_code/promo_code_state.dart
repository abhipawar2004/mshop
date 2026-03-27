import 'package:equatable/equatable.dart';

import '../../model/promo_code_model.dart';

abstract class PromoCodeState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PromoCodeInitial extends PromoCodeState {}

class PromoCodeLoading extends PromoCodeState {}

class PromoCodeLoaded extends PromoCodeState {
  final List<PromoCodeData> promoCodeData;
  final String message;
  final bool hasReachedMax;

  PromoCodeLoaded({
    required this.message,
    required this.promoCodeData,
    required this.hasReachedMax,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, promoCodeData, hasReachedMax];
}

class PromoCodeFailed extends PromoCodeState {
  final String error;

  PromoCodeFailed({required this.error});

  @override
  List<Object?> get props => [error];
}

class PromoCodeSelected extends PromoCodeState {
  final String promoCode;

  PromoCodeSelected({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
}

class PromoCodeRemoved extends PromoCodeState {
  final String promoCode;

  PromoCodeRemoved({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
}

class PromoCodeRemoving extends PromoCodeState {}

class PromoCodeApplying extends PromoCodeState {}