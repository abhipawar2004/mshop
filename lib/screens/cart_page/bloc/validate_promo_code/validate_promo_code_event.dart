part of 'validate_promo_code_bloc.dart';

abstract class ValidatePromoCodeEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ValidatePromoCodeRequest extends ValidatePromoCodeEvent {
  final int? cartAmount;
  final int? deliveryCharges;
  final String? promoCode;

  ValidatePromoCodeRequest({this.cartAmount,this.deliveryCharges,this.promoCode});
  @override
  // TODO: implement props
  List<Object?> get props => [cartAmount, deliveryCharges, promoCode];
}