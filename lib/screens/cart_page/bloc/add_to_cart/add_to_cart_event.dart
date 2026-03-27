import 'package:equatable/equatable.dart';

abstract class AddToCartEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddItemToCart extends AddToCartEvent{
  final int productVariantId;
  final int storeId;
  final int quantity;

  AddItemToCart({required this.productVariantId, required this.storeId, required this.quantity});

  @override
  // TODO: implement props
  List<Object?> get props => [productVariantId, storeId, quantity];
}
