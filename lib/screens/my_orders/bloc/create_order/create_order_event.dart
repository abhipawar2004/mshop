part of 'create_order_bloc.dart';

abstract class CreateOrderEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateOrderRequest extends CreateOrderEvent {
  final String paymentType;
  final String? promoCode;
  final String? giftCard;
  final int addressId;
  final bool? rushDelivery;
  final bool? useWallet;
  final String? orderNote;
  final Map<String, dynamic>? paymentDetails;
  final Map<int, CartItemAttachment?>? attachments;

  CreateOrderRequest({
    required this.paymentType,
    this.promoCode,
    this.giftCard,
    required this.addressId,
    this.rushDelivery,
    this.useWallet,
    this.orderNote,
    this.paymentDetails,
    this.attachments
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    paymentType,
    promoCode,
    giftCard,
    addressId,
    rushDelivery,
    useWallet,
    orderNote,
    paymentDetails,
    attachments
  ];
}
