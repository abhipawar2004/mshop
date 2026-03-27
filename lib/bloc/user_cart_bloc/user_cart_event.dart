import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/user_cart_model/user_cart.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final UserCart item;
  final BuildContext context;

  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isFromCartPage;

  AddToCart({this.addressId,
  this.promoCode, this.rushDelivery, this.useWallet, required this.item, required this.context, this.isFromCartPage = false,});

  @override
  List<Object?> get props => [item, context, addressId, promoCode, rushDelivery, useWallet, isFromCartPage];
}

class UpdateCartQty extends CartEvent {
  final String cartKey;
  final int quantity;
  final int? cartItemId;
  final BuildContext context;
  final bool? isFromCartPage;

  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;

  UpdateCartQty({required this.cartKey, required this.quantity, this.cartItemId, required this.context, this.addressId,
    this.promoCode, this.rushDelivery, this.useWallet, this.isFromCartPage = false,});

  @override
  List<Object?> get props => [cartKey, quantity, cartItemId, context, addressId, promoCode, rushDelivery, useWallet, isFromCartPage];
}

class RemoveFromCart extends CartEvent {
  final String cartKey;
  final BuildContext context;

  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isFromCartPage;

  RemoveFromCart({required this.cartKey, required this.context, this.addressId,
    this.promoCode, this.rushDelivery, this.useWallet,  this.isFromCartPage = false,});

  @override
  List<Object?> get props => [cartKey, context, addressId, promoCode, rushDelivery, useWallet, isFromCartPage];
}

class RemoveLocally extends CartEvent {
  final String cartKey;
  final BuildContext context;
  RemoveLocally(this.cartKey, this.context);
}

class ClearCart extends CartEvent {
  final BuildContext context;
  ClearCart({required this.context});
}

class SyncLocalCart extends CartEvent {
  final BuildContext context;

  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isFromCartPage;

  SyncLocalCart({required this.context, this.addressId,
    this.promoCode, this.rushDelivery, this.useWallet, this.isFromCartPage = false,});
  @override
  List<Object?> get props => [context, addressId, promoCode, rushDelivery, useWallet, isFromCartPage];
}
