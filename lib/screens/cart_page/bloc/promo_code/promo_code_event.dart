import 'package:equatable/equatable.dart';

abstract class PromoCodeEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchPromoCode extends PromoCodeEvent {}

class SelectPromoCode extends PromoCodeEvent {
  final String promoCode;

  SelectPromoCode(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

class RemovePromoCode extends PromoCodeEvent {}
