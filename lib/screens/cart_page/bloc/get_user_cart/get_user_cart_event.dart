part of 'get_user_cart_bloc.dart';

abstract class GetUserCartEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchUserCart extends GetUserCartEvent {
  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isRefresh;

  FetchUserCart(
      {this.addressId,
        this.promoCode, this.rushDelivery, this.useWallet,
        this.isRefresh = false
      });

  @override
  // TODO: implement props
  List<Object?> get props => [addressId,
    promoCode, rushDelivery, useWallet, isRefresh
  ];
}

class RefreshUserCart extends GetUserCartEvent {
  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isRefresh;

  RefreshUserCart({
    this.addressId,
    this.promoCode,
    this.rushDelivery,
    this.useWallet,
    this.isRefresh = true
  });

  @override
  List<Object?> get props => [addressId, promoCode, rushDelivery, useWallet, isRefresh];
}

class UpdateUserCart extends GetUserCartEvent {
  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;

  UpdateUserCart(
      {this.addressId,
        this.promoCode, this.rushDelivery, this.useWallet
      });

  @override
  // TODO: implement props
  List<Object?> get props => [addressId,
    promoCode, rushDelivery, useWallet
  ];
}

class FallbackToRegularDelivery extends GetUserCartEvent {
  final int? addressId;

  FallbackToRegularDelivery({this.addressId});
}

class SyncCart extends GetUserCartEvent {}

class SyncServerCartToLocal extends GetUserCartEvent {
  final List<Map<String, dynamic>> serverItems;

  SyncServerCartToLocal({required this.serverItems});
}
