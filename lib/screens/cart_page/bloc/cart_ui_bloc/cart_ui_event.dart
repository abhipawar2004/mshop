import 'package:equatable/equatable.dart';
import '../../../../config/payment_config.dart';
import '../../../address_list_page/model/get_address_list_model.dart';
import '../../widgets/delivery_type_widget.dart';

abstract class CartUIEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetSelectedAddress extends CartUIEvent {
  final AddressListData? address;
  SetSelectedAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class SetDeliveryType extends CartUIEvent {
  final DeliveryType type;
  SetDeliveryType(this.type);

  @override
  List<Object?> get props => [type];
}

class SetWalletUsage extends CartUIEvent {
  final bool useWallet;
  SetWalletUsage(this.useWallet);

  @override
  List<Object?> get props => [useWallet];
}

class SetPaymentMethod extends CartUIEvent {
  final String? paymentMethodId;
  final PaymentMethodType? paymentMethodType;

  SetPaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodType,
  });

  @override
  List<Object?> get props => [paymentMethodId, paymentMethodType];
}

class SetTotalAmount extends CartUIEvent {
  final double amount;
  SetTotalAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SetCartLoading extends CartUIEvent {
  final bool isLoading;
  SetCartLoading(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

class SetWalletLoading extends CartUIEvent {
  final bool isLoading;
  SetWalletLoading(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

class SetWholePageProgress extends CartUIEvent {
  final bool show;
  SetWholePageProgress(this.show);

  @override
  List<Object?> get props => [show];
}
