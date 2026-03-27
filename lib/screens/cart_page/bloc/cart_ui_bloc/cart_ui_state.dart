import 'package:equatable/equatable.dart';
import '../../../../config/payment_config.dart';
import '../../../address_list_page/model/get_address_list_model.dart';
import '../../widgets/delivery_type_widget.dart';

class CartUIState extends Equatable {
  final AddressListData? selectedAddress;
  final DeliveryType selectedDeliveryType;
  final bool useWallet;
  final bool isCartLoading;
  final bool isWalletLoading;
  final bool isWholePageProgress;
  final double totalAmount;

  final String? selectedPaymentMethod;
  final PaymentMethodType? selectedPaymentMethodType;

  const CartUIState({
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.selectedPaymentMethodType,
    this.selectedDeliveryType = DeliveryType.regular,
    this.useWallet = false,
    this.isCartLoading = false,
    this.isWalletLoading = false,
    this.isWholePageProgress = false,
    this.totalAmount = 0.0,
  });

  CartUIState copyWith({
    AddressListData? selectedAddress,
    DeliveryType? selectedDeliveryType,
    bool? useWallet,
    bool? isCartLoading,
    bool? isWalletLoading,
    bool? isWholePageProgress,
    double? totalAmount,
    String? selectedPaymentMethod,
    PaymentMethodType? selectedPaymentMethodType,
  }) {
    return CartUIState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedDeliveryType:
      selectedDeliveryType ?? this.selectedDeliveryType,
      useWallet: useWallet ?? this.useWallet,
      isCartLoading: isCartLoading ?? this.isCartLoading,
      isWalletLoading: isWalletLoading ?? this.isWalletLoading,
      isWholePageProgress:
      isWholePageProgress ?? this.isWholePageProgress,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedPaymentMethodType:
      selectedPaymentMethodType ?? this.selectedPaymentMethodType,
    );
  }

  @override
  List<Object?> get props => [
    selectedAddress,
    selectedDeliveryType,
    useWallet,
    isCartLoading,
    isWalletLoading,
    isWholePageProgress,
    totalAmount,
    selectedPaymentMethod,
    selectedPaymentMethodType,
  ];
}
